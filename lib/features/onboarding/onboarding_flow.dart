import 'dart:async';

import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/domain/services/auth_service.dart';
import 'package:budget/domain/services/notification_service.dart';
import 'package:budget/domain/services/onboarding_service.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
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
  final int dueDay;
  final String hint;
  final bool variable;

  bool enabled = false;
  final controller = TextEditingController();
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
  final _envelopeLimit = TextEditingController();
  int? _envelopeCategoryId;
  bool _enableNotif = true;
  bool _enableBiometric = false;

  late final List<_ChargePreset> _charges = [
    _ChargePreset('Loyer', 'Logement', 'home', 5, '800'),
    _ChargePreset('Électricité', 'Électricité', 'bolt', 10, '90', variable: true),
    _ChargePreset('Eau', 'Eau', 'water', 15, '35', variable: true),
    _ChargePreset('Internet', 'Internet', 'wifi', 8, '35'),
    _ChargePreset('Téléphone', 'Téléphone', 'phone', 8, '20'),
    _ChargePreset('Assurances', 'Assurances', 'insurance', 5, '40'),
  ];

  static const _lastPage = 5;

  @override
  void dispose() {
    _controller.dispose();
    _salary.dispose();
    _envelopeLimit.dispose();
    for (final c in _charges) {
      c.controller.dispose();
    }
    super.dispose();
  }

  Money? _money(TextEditingController c) {
    final v = double.tryParse(c.text.trim().replaceAll(',', '.'));
    if (v == null || v <= 0) return null;
    return Money.fromEuros(v);
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
      final granted = await NotificationService.instance.requestPermission();
      await repo.putBool(SettingKeys.notificationsEnabled, value: granted);
    }
    if (_enableBiometric) {
      final ok = await AuthService.instance.authenticate();
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
    ];

    await ref.read(onboardingServiceProvider).completeSetup(
      startDay: _startDay,
      salaryCents: _money(_salary)?.cents,
      salaryDay: _startDay,
      charges: charges,
      envelopeCategoryId: _envelopeCategoryId,
      envelopeLimitCents: _money(_envelopeLimit)?.cents,
    );
    // Gate switches to the app automatically.
  }

  @override
  Widget build(BuildContext context) {
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
                  _envelopeStep(),
                  _optionsStep(),
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
    title: 'Ton mois commence quand ?',
    subtitle:
        'Choisis le jour où débute ton budget. Le 1er par défaut, ou le jour '
        'de ta paie si ton salaire tombe en fin de mois.',
    child: _DayPicker(
      day: _startDay,
      onChanged: (d) => setState(() => _startDay = d),
    ),
  );

  Widget _salaryStep() => _StepScaffold(
    icon: Icons.payments_outlined,
    title: 'Quel est ton revenu mensuel ?',
    subtitle:
        'Ton salaire net habituel. Il sera pré-rempli chaque mois — tu pourras '
        'l\'ajuster à tout moment. Tu peux aussi laisser vide.',
    child: TextField(
      controller: _salary,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      decoration: const InputDecoration(
        hintText: '0',
        suffixText: '€',
        border: InputBorder.none,
        filled: false,
      ),
    ),
  );

  Widget _chargesStep() => _StepScaffold(
    icon: Icons.receipt_long_outlined,
    title: 'Tes charges fixes',
    subtitle:
        'Coche celles que tu as et indique leur montant. Elles reviendront '
        'automatiquement chaque mois.',
    child: Column(
      children: [
        for (final c in _charges) _ChargeRow(preset: c, onChanged: _rebuild),
      ],
    ),
  );

  Widget _envelopeStep() {
    final categories = (ref.watch(categoriesProvider).value ?? const [])
        .where((c) => c.parentId == null && c.kind.name == 'expense')
        .where(
          (c) => const [
            'Alimentation',
            'Loisirs',
            'Shopping',
            'Transport',
          ].contains(c.name),
        )
        .toList();

    return _StepScaffold(
      icon: Icons.pie_chart_outline,
      title: 'Une première enveloppe ? (facultatif)',
      subtitle:
          'Fixe-toi un plafond sur une catégorie pour éviter de déraper. '
          'Par exemple 300 € de courses par mois.',
      child: Column(
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment: WrapAlignment.center,
            children: [
              for (final c in categories)
                ChoiceChip(
                  avatar: Icon(
                    iconFor(c.iconKey),
                    size: 18,
                    color: Color(c.colorValue),
                  ),
                  label: Text(c.name),
                  selected: _envelopeCategoryId == c.id,
                  onSelected: (s) => setState(
                    () => _envelopeCategoryId = s ? c.id : null,
                  ),
                ),
            ],
          ),
          if (_envelopeCategoryId != null) ...[
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _envelopeLimit,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Plafond mensuel',
                suffixText: '€',
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _optionsStep() => _StepScaffold(
    icon: Icons.tune,
    title: 'Presque fini !',
    subtitle: 'Deux options pour t\'aider au quotidien. Tu peux les changer '
        'plus tard dans les réglages.',
    child: Column(
      children: [
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text("Rappels d'échéance"),
            subtitle: const Text('3 jours avant et le jour de chaque charge'),
            value: _enableNotif,
            onChanged: (v) => setState(() => _enableNotif = v),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: SwitchListTile(
            secondary: const Icon(Icons.fingerprint),
            title: const Text('Verrouillage biométrique'),
            subtitle: const Text('Empreinte ou code à l\'ouverture'),
            value: _enableBiometric,
            onChanged: (v) => setState(() => _enableBiometric = v),
          ),
        ),
      ],
    ),
  );

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
          const SizedBox(height: AppSpacing.xl),
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
          const SizedBox(height: AppSpacing.xl),
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

  String _label(int d) => d == 1 ? 'le 1er' : 'le $d';

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
              ),
              const SizedBox(width: AppSpacing.lg),
              SizedBox(
                width: 130,
                child: Text(
                  _label(day),
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
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.sm,
          children: [
            for (final (label, d) in const [
              ('Le 1er', 1),
              ('Le 15', 15),
              ('Le 25', 25),
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
  const _ChargeRow({required this.preset, required this.onChanged});

  final _ChargePreset preset;
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
              preset.enabled = v ?? false;
              onChanged();
            },
          ),
          Icon(iconFor(preset.icon), size: 20, color: scheme.onSurfaceVariant),
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
                suffixText: '€',
                isDense: true,
              ),
              onTap: () {
                if (!preset.enabled) {
                  preset.enabled = true;
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
                color: i == page
                    ? scheme.primary
                    : scheme.surfaceContainerHighest,
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
            TextButton(onPressed: onBack, child: const Text('Retour')),
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
