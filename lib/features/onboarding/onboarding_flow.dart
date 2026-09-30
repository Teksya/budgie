import 'dart:async';

import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/domain/services/auth_service.dart';
import 'package:budget/domain/services/notification_service.dart';
import 'package:budget/domain/services/onboarding_service.dart';
import 'package:budget/features/onboarding/subscription_presets.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/widgets/budget_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A fixed-charge suggestion offered during setup.
class _ChargePreset {
  _ChargePreset(this.label, this.category, this.icon, this.dueDay, this.hint,
      {this.variable = false});

  final String label;
  final String category;
  final String icon;
  final String hint;
  final bool variable;

  /// Day of the month it is taken. Pre-filled, then picked on a calendar.
  int dueDay;

  bool enabled = false;
  final controller = TextEditingController();

  /// Ticking a row promotes its hint to a real value. Otherwise the greyed
  /// "800" reads as configured while an empty field silently drops the charge.
  void enable() {
    enabled = true;
    if (controller.text.isEmpty) controller.text = hint;
  }
}

/// A subscription the user picked, with the two things the app needs.
class _SubPick {
  _SubPick(this.cents, this.day);

  final int cents;
  final int day;
}

/// A spending cap suggestion offered during setup.
class _EnvelopePreset {
  _EnvelopePreset(this.category, this.icon, this.hint);

  final String category;
  final String icon;
  final String hint;

  bool enabled = false;
  final controller = TextEditingController();

  void enable() {
    enabled = true;
    if (controller.text.isEmpty) controller.text = hint;
  }
}

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  final _controller = PageController();
  int _page = 0;
  bool _busy = false;

  int _startDay = 1;
  final _salary = TextEditingController();

  // `late final` so these are built once, on first read from `build` — by then
  // the context is live. The category names have to be the *translated* ones:
  // they are matched against the category rows seeded in the same language.
  late final List<_ChargePreset> _charges = [
    _ChargePreset(_l.chargeRent, _l.catHousing, 'home', 5, '800'),
    _ChargePreset(
      _l.catElectricity,
      _l.catElectricity,
      'bolt',
      10,
      '90',
      variable: true,
    ),
    _ChargePreset(_l.catWater, _l.catWater, 'water', 15, '35', variable: true),
    _ChargePreset(_l.catInternet, _l.catInternet, 'wifi', 8, '35'),
    _ChargePreset(_l.catPhone, _l.catPhone, 'phone', 8, '20'),
    _ChargePreset(_l.catInsurance, _l.catInsurance, 'insurance', 5, '40'),
  ];

  L get _l => L.of(context);

  /// Picked subscriptions, keyed by preset name.
  final Map<String, _SubPick> _subs = {};

  late final List<_EnvelopePreset> _envelopes = [
    _EnvelopePreset(_l.catGroceries, 'cart', '300'),
    _EnvelopePreset(_l.catRestaurant, 'restaurant', '120'),
    _EnvelopePreset(_l.catLeisure, 'fun', '80'),
    _EnvelopePreset(_l.catTransport, 'car', '100'),
  ];
  int? _customCategoryId;
  final _customLimit = TextEditingController();

  bool _enableNotif = true;
  bool _enableBiometric = false;

  static const _lastPage = 7;

  @override
  void dispose() {
    _controller.dispose();
    _salary.dispose();
    _customLimit.dispose();
    for (final c in _charges) {
      c.controller.dispose();
    }
    for (final e in _envelopes) {
      e.controller.dispose();
    }
    super.dispose();
  }

  Money? _money(TextEditingController c) {
    final v = double.tryParse(c.text.trim().replaceAll(',', '.'));
    if (v == null || v <= 0) return null;
    return Money.fromEuros(v);
  }

  List<Category> get _categories =>
      ref.read(categoriesProvider).value ?? const [];

  int? _categoryIdByName(String name) {
    for (final c in _categories) {
      if (c.name == name) return c.id;
    }
    return null;
  }

  /// Picks a day of the month on a real calendar, bounded to the current
  /// month so the user never has to think about which month they are in.
  Future<int?> _pickDay(BuildContext context, int current) async {
    final now = DateTime.now();
    final last = DateTime(now.year, now.month + 1, 0);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, now.month, current.clamp(1, last.day)),
      firstDate: DateTime(now.year, now.month),
      lastDate: last,
      helpText: L.of(context).debitDayHelp,
    );
    return picked?.day;
  }

  void _next() {
    if (_page < _lastPage) {
      unawaited(
        _controller.nextPage(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        ),
      );
    } else {
      unawaited(_finish());
    }
  }

  void _back() => unawaited(
    _controller.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    ),
  );

  Future<void> _finish() async {
    setState(() => _busy = true);
    final repo = ref.read(settingsRepositoryProvider);

    if (_enableNotif) {
      final granted = await NotificationService.instance.requestPermission(_l);
      await repo.putBool(SettingKeys.notificationsEnabled, value: granted);
    }
    if (_enableBiometric) {
      final ok = await AuthService.instance.authenticate(_l.unlockReason);
      await repo.putBool(SettingKeys.biometricEnabled, value: ok);
    }

    final charges = [
      for (final c in _charges)
        if (c.enabled && _money(c.controller) != null)
          OnboardingCharge(
            name: c.label,
            categoryName: c.category,
            amountCents: _money(c.controller)!.cents,
            dueDay: c.dueDay,
            isVariable: c.variable,
          ),
      for (final p in kSubscriptionPresets)
        if (_subs[p.name] case final s?)
          OnboardingCharge(
            name: p.name,
            categoryName: 'Abonnements',
            amountCents: s.cents,
            dueDay: s.day,
            nature: RecurrenceNature.subscription,
          ),
    ];

    final envelopes = [
      for (final e in _envelopes)
        if (e.enabled && _money(e.controller) != null)
          if (_categoryIdByName(e.category) case final id?)
            OnboardingEnvelope(
              categoryId: id,
              limitCents: _money(e.controller)!.cents,
            ),
      if (_customCategoryId != null && _money(_customLimit) != null)
        OnboardingEnvelope(
          categoryId: _customCategoryId!,
          limitCents: _money(_customLimit)!.cents,
        ),
    ];

    await ref.read(onboardingServiceProvider).completeSetup(
      startDay: _startDay,
      salaryCents: _money(_salary)?.cents,
      salaryDay: _startDay,
      charges: charges,
      envelopes: envelopes,
    );
    // Gate switches to the app automatically.
  }

  @override
  Widget build(BuildContext context) {
    // Watched, not read: the seed categories land asynchronously. Without a
    // subscription here the stream is never listened to, so `_categories` stays
    // empty — envelopes would be dropped on save and the recap ring would fall
    // back to a single flat colour.
    ref.watch(categoriesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _ProgressDots(page: _page, count: _lastPage + 1),
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (p) => setState(() => _page = p),
                children: [
                  const _WelcomeStep(),
                  _startDayStep(),
                  _salaryStep(),
                  _chargesStep(),
                  _subscriptionsStep(),
                  _envelopeStep(),
                  _optionsStep(),
                  _recapStep(),
                ],
              ),
            ),
            _NavBar(
              page: _page,
              lastPage: _lastPage,
              busy: _busy,
              onBack: _page == 0 ? null : _back,
              onNext: _busy ? null : _next,
            ),
          ],
        ),
      ),
    );
  }

  // ── Steps ─────────────────────────────────────────────────────────────

  Widget _startDayStep() => _StepScaffold(
    icon: Icons.event_outlined,
    title: _l.onboardStartDayTitle,
    subtitle: _l.onboardStartDayBody,
    child: _DayPicker(
      day: _startDay,
      onChanged: (d) => setState(() => _startDay = d),
    ),
  );

  Widget _salaryStep() => _StepScaffold(
    icon: Icons.payments_outlined,
    title: _l.onboardSalaryTitle,
    subtitle: _l.onboardSalaryBody,
    child: TextField(
      controller: _salary,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: '0',
        suffixText: AppCurrency.instance.symbol,
        border: InputBorder.none,
        filled: false,
      ),
    ),
  );

  Widget _chargesStep() => _StepScaffold(
    icon: Icons.receipt_long_outlined,
    title: _l.onboardChargesTitle,
    subtitle: _l.onboardChargesBody,
    child: Column(
      children: [
        for (final c in _charges)
          _ChargeRow(
            preset: c,
            onChanged: _rebuild,
            onPickDay: () async {
              final d = await _pickDay(context, c.dueDay);
              if (d != null) setState(() => c.dueDay = d);
            },
          ),
      ],
    ),
  );

  Widget _subscriptionsStep() => _StepScaffold(
    icon: Icons.subscriptions_outlined,
    title: _l.onboardSubsTitle,
    subtitle: _subs.isEmpty
        ? _l.onboardSubsBody
        : _l.onboardSubsCount(_subs.length, _subsTotal.format()),
    child: Wrap(
      alignment: WrapAlignment.center,
      children: [
        for (final p in kSubscriptionPresets)
          _SubTile(
            preset: p,
            pick: _subs[p.name],
            onTap: () => unawaited(_editSub(p)),
          ),
      ],
    ),
  );

  Money get _subsTotal =>
      _subs.values.fold(Money.zero, (a, s) => a + Money(s.cents));

  Future<void> _editSub(SubscriptionPreset preset) async {
    final existing = _subs[preset.name];
    final amount = TextEditingController(
      text: (existing == null ? preset.euros : existing.cents / 100)
          .toStringAsFixed(2)
          .replaceAll('.', ','),
    );
    var day = existing?.day ?? DateTime.now().day;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: AppShapes.sheet,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            bottom:
                MediaQuery.viewInsetsOf(sheetContext).bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  _Monogram(preset: preset, size: 44),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      preset.name,
                      style: Theme.of(sheetContext).textTheme.titleLarge,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              OutlinedButton.icon(
                onPressed: () async {
                  final d = await _pickDay(sheetContext, day);
                  if (d != null) setSheet(() => day = d);
                },
                icon: const Icon(Icons.event_outlined),
                label: Text(_l.debitedOnEveryMonth(day)),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: amount,
                autofocus: existing == null,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: _l.monthlyAmount,
                  suffixText: AppCurrency.instance.symbol,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () {
                  final m = _money(amount);
                  if (m == null) return;
                  setState(() => _subs[preset.name] = _SubPick(m.cents, day));
                  Navigator.of(sheetContext).pop();
                },
                child: Text(existing == null ? _l.actionAdd : _l.actionSave),
              ),
              if (existing != null)
                TextButton(
                  onPressed: () {
                    setState(() => _subs.remove(preset.name));
                    Navigator.of(sheetContext).pop();
                  },
                  child: Text(_l.actionRemove),
                ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
    amount.dispose();
  }

  Widget _envelopeStep() {
    // Anything that isn't already a suggestion above, for the "other" slot.
    final used = _envelopes.map((e) => e.category).toSet();
    final others = _categories
        .where(
          (c) =>
              c.kind == CategoryKind.expense &&
              c.parentId == null &&
              c.name != _l.uncategorized &&
              !used.contains(c.name),
        )
        .toList();

    return _StepScaffold(
      icon: Icons.pie_chart_outline,
      title: _l.onboardEnvelopesTitle,
      subtitle: _l.onboardEnvelopesBody,
      child: Column(
        children: [
          for (final e in _envelopes)
            _EnvelopeRow(preset: e, onChanged: _rebuild),
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          DropdownButtonFormField<int?>(
            initialValue: _customCategoryId,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: _l.onboardAnotherBudget,
              prefixIcon: const Icon(Icons.add),
            ),
            items: [
              DropdownMenuItem<int?>(child: Text(_l.none)),
              for (final c in others)
                DropdownMenuItem(
                  value: c.id,
                  child: Row(
                    children: [
                      Icon(
                        iconFor(c.iconKey),
                        size: 18,
                        color: Color(c.colorValue),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(c.name),
                    ],
                  ),
                ),
            ],
            onChanged: (v) => setState(() => _customCategoryId = v),
          ),
          if (_customCategoryId != null) ...[
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _customLimit,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: _l.monthlyCap,
                suffixText: AppCurrency.instance.symbol,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _optionsStep() => _StepScaffold(
    icon: Icons.tune,
    title: _l.onboardOptionsTitle,
    subtitle: _l.onboardOptionsBody,
    child: Column(
      children: [
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(_l.dueReminders),
            subtitle: Text(_l.onboardRemindersSub),
            value: _enableNotif,
            onChanged: (v) => setState(() => _enableNotif = v),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: Text(_l.biometricLock),
            subtitle: Text(_l.onboardBiometricSub),
            value: _enableBiometric,
            onChanged: (v) => setState(() => _enableBiometric = v),
          ),
        ),
      ],
    ),
  );

  /// The payoff: everything just entered, as one ring.
  Widget _recapStep() {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    Color colorOf(String name, Color fallback) {
      for (final c in _categories) {
        if (c.name == name) return Color(c.colorValue);
      }
      return fallback;
    }

    final chargesTotal = _charges
        .where((c) => c.enabled)
        .fold(Money.zero, (a, c) => a + (_money(c.controller) ?? Money.zero));

    final segments = <RingSegment>[
      RingSegment(
        label: _l.ringCharges,
        color: scheme.primary,
        amount: chargesTotal.euros,
      ),
      RingSegment(
        label: _l.catSubscriptions,
        color: scheme.tertiary,
        amount: _subsTotal.euros,
      ),
      for (final e in _envelopes)
        if (e.enabled)
          RingSegment(
            label: e.category,
            color: colorOf(e.category, scheme.secondary),
            amount: (_money(e.controller) ?? Money.zero).euros,
          ),
      if (_customCategoryId != null)
        RingSegment(
          label: _customName ?? _l.ringOther,
          color: colorOf(_customName ?? '', scheme.secondary),
          amount: (_money(_customLimit) ?? Money.zero).euros,
        ),
    ];

    final planned = segments.fold<double>(0, (a, s) => a + s.amount);
    final salary = (_money(_salary) ?? Money.zero).euros;
    final free = salary - planned;
    if (free > 0) {
      segments.add(
        RingSegment(
          label: _l.ringFree,
          color: scheme.secondaryContainer,
          amount: free,
        ),
      );
    }

    return _StepScaffold(
      icon: Icons.celebration_outlined,
      title: _l.onboardRecapTitle,
      subtitle: salary > 0
          ? _l.onboardRecapWithSalary(Money.fromEuros(salary).formatRounded())
          : _l.onboardRecapNoSalary,
      child: Column(
        children: [
          BudgetRing(
            segments: segments,
            semanticsLabel: _l.onboardRecapSemantics(
              segments
                  .where((s) => s.amount > 0)
                  .map(
                    (s) =>
                        '${s.label} '
                        '${Money.fromEuros(s.amount).formatRounded()}',
                  )
                  .join(', '),
            ),
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  salary > 0 ? _l.onboardYouWillHaveLeft : _l.onboardCommitted,
                  style: theme.textTheme.labelMedium,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    Money.fromEuros(salary > 0 ? free : planned)
                        .formatRounded(),
                    maxLines: 1,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: free < 0 && salary > 0 ? scheme.error : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          RingLegend(segments: segments),
          if (salary > 0 && free < 0) ...[
            const SizedBox(height: AppSpacing.md),
            Card(
              color: scheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  _l.onboardOverBudget(
                    Money.fromEuros(-free).formatRounded(),
                  ),
                  style: TextStyle(color: scheme.onErrorContainer),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String? get _customName {
    for (final c in _categories) {
      if (c.id == _customCategoryId) return c.name;
    }
    return null;
  }

  void _rebuild() => setState(() {});
}

// ── Building blocks ───────────────────────────────────────────────────────

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l = L.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: ShapeDecoration(
              shape: AppShapes.hero,
              color: scheme.primaryContainer,
            ),
            child: Icon(
              Icons.savings_outlined,
              size: 72,
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            l.onboardWelcomeTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            l.onboardWelcomeSubtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _Highlight(
            icon: Icons.account_balance_wallet_outlined,
            title: l.onboardHl1Title,
            body: l.onboardHl1Body,
          ),
          _Highlight(
            icon: Icons.event_repeat_outlined,
            title: l.onboardHl2Title,
            body: l.onboardHl2Body,
          ),
          _Highlight(
            icon: Icons.notifications_active_outlined,
            title: l.onboardHl3Title,
            body: l.onboardHl3Body,
          ),
          _Highlight(
            icon: Icons.lock_outline,
            title: l.onboardHl4Title,
            body: l.onboardHl4Body,
          ),
        ],
      ),
    );
  }
}

class _Highlight extends StatelessWidget {
  const _Highlight({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: scheme.secondaryContainer,
            foregroundColor: scheme.onSecondaryContainer,
            child: Icon(icon, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  body,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    const pad = EdgeInsets.fromLTRB(
      AppSpacing.xl,
      AppSpacing.lg,
      AppSpacing.xl,
      AppSpacing.lg,
    );

    // `mainAxisSize: min` keeps the column's height finite under the scroll
    // view's unbounded height (the cause of the grey render-error box), while
    // the tight width from the padding lets Slider/TextField lay out cleanly.
    return SingleChildScrollView(
      padding: pad,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.lg),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: ShapeDecoration(
                shape: AppShapes.card,
                color: scheme.secondaryContainer,
              ),
              child: Icon(icon, color: scheme.onSecondaryContainer),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          child,
        ],
      ),
    );
  }
}

/// Clear day-of-month picker: a big number with − / + and quick shortcuts.
/// No Slider — steppers read better for the general public and avoid the
/// Overlay dependency a Slider carries.
class _DayPicker extends StatelessWidget {
  const _DayPicker({required this.day, required this.onChanged});

  final int day;
  final ValueChanged<int> onChanged;

  String _label(BuildContext context, int d) => d == 1
      ? L.of(context).periodStartFirstShort
      : L.of(context).dayOrdinal(d);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: ShapeDecoration(
            shape: AppShapes.hero,
            color: scheme.primaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton.filledTonal(
                onPressed: day > 1 ? () => onChanged(day - 1) : null,
                icon: const Icon(Icons.remove),
                tooltip: L.of(context).previousDay,
              ),
              const SizedBox(width: AppSpacing.lg),
              SizedBox(
                width: 130,
                child: Text(
                  _label(context, day),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              IconButton.filledTonal(
                onPressed: day < 28 ? () => onChanged(day + 1) : null,
                icon: const Icon(Icons.add),
                tooltip: L.of(context).nextDay,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          children: [
            for (final (label, d) in [
              (L.of(context).periodStartFirstShortCap, 1),
              (L.of(context).dayOrdinalCap(15), 15),
              (L.of(context).dayOrdinalCap(25), 25),
            ])
              ChoiceChip(
                label: Text(label),
                selected: day == d,
                onSelected: (_) => onChanged(d),
              ),
          ],
        ),
      ],
    );
  }
}

class _ChargeRow extends StatelessWidget {
  const _ChargeRow({
    required this.preset,
    required this.onChanged,
    required this.onPickDay,
  });

  final _ChargePreset preset;
  final VoidCallback onChanged;
  final VoidCallback onPickDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: preset.enabled,
                onChanged: (v) {
                  if (v ?? false) {
                    preset.enable();
                  } else {
                    preset.enabled = false;
                  }
                  onChanged();
                },
              ),
              Icon(
                iconFor(preset.icon),
                size: 20,
                color: scheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(preset.label)),
              SizedBox(
                width: 110,
                child: TextField(
                  controller: preset.controller,
                  enabled: preset.enabled,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    hintText: preset.hint,
                    suffixText: AppCurrency.instance.symbol,
                    isDense: true,
                  ),
                  onTap: () {
                    if (!preset.enabled) {
                      preset.enable();
                      onChanged();
                    }
                  },
                ),
              ),
            ],
          ),
          // The date only matters once the charge is actually kept.
          if (preset.enabled)
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: TextButton.icon(
                  onPressed: onPickDay,
                  icon: const Icon(Icons.event_outlined, size: 18),
                  label: Text(L.of(context).debitedOn(preset.dueDay)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    textStyle: theme.textTheme.labelMedium,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EnvelopeRow extends StatelessWidget {
  const _EnvelopeRow({required this.preset, required this.onChanged});

  final _EnvelopePreset preset;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Checkbox(
            value: preset.enabled,
            onChanged: (v) {
              if (v ?? false) {
                preset.enable();
              } else {
                preset.enabled = false;
              }
              onChanged();
            },
          ),
          Icon(iconFor(preset.icon), size: 20, color: scheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(preset.category)),
          SizedBox(
            width: 110,
            child: TextField(
              controller: preset.controller,
              enabled: preset.enabled,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                hintText: preset.hint,
                suffixText: AppCurrency.instance.symbol,
                isDense: true,
              ),
              onTap: () {
                if (!preset.enabled) {
                  preset.enable();
                  onChanged();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// The brand square: the real mark when the icon set has it, the coloured
/// monogram otherwise. See [SubscriptionPreset] for why some have neither.
class _Monogram extends StatelessWidget {
  const _Monogram({required this.preset, this.selected = false, this.size = 52});

  final SubscriptionPreset preset;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = preset.color;
    // Brand colours run from near-black to bright red; pick the readable ink.
    final ink = ThemeData.estimateBrightnessForColor(brand) == Brightness.dark
        ? Colors.white
        : Colors.black87;

    // A bundled PNG is a full app icon: it brings its own background, so the
    // tile just clips it. Font glyphs get the brand colour behind them.
    final asset = preset.asset;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: asset == null ? brand : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: selected ? scheme.primary : Colors.transparent,
          width: 3,
        ),
      ),
      child: switch ((asset, preset.icon)) {
        (final String a, _) => Image.asset(a, fit: BoxFit.cover),
        (_, final IconData i?) => Icon(i, color: ink, size: size * 0.46),
        _ => Text(
          preset.short,
          style: TextStyle(
            color: ink,
            fontWeight: FontWeight.w800,
            fontSize: size * 0.34,
          ),
        ),
      },
    );
  }
}

class _SubTile extends StatelessWidget {
  const _SubTile({
    required this.preset,
    required this.pick,
    required this.onTap,
  });

  final SubscriptionPreset preset;
  final _SubPick? pick;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final picked = pick;

    return SizedBox(
      // Four to a row on a phone; the label block is fixed so the rows of the
      // grid line up whether a name wraps or not.
      width: 76,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Semantics(
          button: true,
          selected: picked != null,
          label: picked == null
              ? preset.name
              : '${preset.name}, ${Money(picked.cents).format()} '
                    'le ${picked.day} de chaque mois',
          excludeSemantics: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _Monogram(preset: preset, selected: picked != null),
                    if (picked != null)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: CircleAvatar(
                          radius: 11,
                          backgroundColor: scheme.primary,
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: scheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 30,
                  child: Text(
                    preset.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall,
                  ),
                ),
                Text(
                  picked == null ? '' : Money(picked.cents).format(),
                  maxLines: 1,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.page, required this.count});

  final int page;
  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == page ? 22 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == page ? scheme.primary : scheme.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.page,
    required this.lastPage,
    required this.busy,
    required this.onBack,
    required this.onNext,
  });

  final int page;
  final int lastPage;
  final bool busy;
  final VoidCallback? onBack;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          if (onBack != null)
            TextButton(
              onPressed: onBack,
              child: Text(L.of(context).actionBack),
            ),
          const Spacer(),
          FilledButton(
            onPressed: onNext,
            child: busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    page == 0
                        ? L.of(context).onboardStart
                        : (page == lastPage
                              ? L.of(context).onboardDone
                              : L.of(context).actionContinue),
                  ),
          ),
        ],
      ),
    );
  }
}
