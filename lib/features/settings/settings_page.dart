import 'dart:io';

import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/data/repositories/settings_repository.dart';
import 'package:budget/domain/services/auth_service.dart';
import 'package:budget/domain/services/notification_service.dart';
import 'package:budget/features/settings/exchange_rates_page.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final settings = ref.watch(settingsProvider).value ?? const {};
    final repo = ref.watch(settingsRepositoryProvider);
    final themeMode = settings[SettingKeys.themeMode] ?? 'system';

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settingsTitle),
        // BackButton, not a bare IconButton: it carries the localised
        // "Retour" tooltip and semantics that a raw arrow icon does not.
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          _SectionTitle(l.settingsAppearance),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: Text(l.settingsTheme),
                  subtitle: Text(switch (themeMode) {
                    'light' => l.themeLight,
                    'dark' => l.themeDark,
                    _ => l.themeSystem,
                  }),
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'system',
                        icon: Icon(Icons.brightness_auto),
                      ),
                      ButtonSegment(
                        value: 'light',
                        icon: Icon(Icons.light_mode),
                      ),
                      ButtonSegment(
                        value: 'dark',
                        icon: Icon(Icons.dark_mode),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (s) =>
                        repo.put(SettingKeys.themeMode, s.first),
                    showSelectedIcon: false,
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.palette_outlined),
                  title: Text(l.dynamicColors),
                  subtitle: Text(l.dynamicColorsSub),
                  value: settings.useDynamicColor,
                  onChanged: (v) => repo.putBool(
                    SettingKeys.useDynamicColor,
                    value: v,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(l.settingsGeneral),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(l.settingsLanguage),
                  subtitle: Text(switch (settings[SettingKeys.language]) {
                    'fr' => l.languageFrench,
                    'en' => l.languageEnglish,
                    _ => l.languageSystem,
                  }),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickLanguage(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.euro_outlined),
                  title: Text(l.settingsCurrency),
                  subtitle: Text(
                    '${settings.currency} · '
                    '${kCurrencies[settings.currency] ?? ''}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickCurrency(context, ref, settings.currency),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.swap_horiz),
                  title: Text(l.settingsRates),
                  subtitle: Text(l.settingsRatesSub),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ExchangeRatesPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(l.settingsPeriod),
          Card(
            child: _PeriodStartTile(
              startDay: settings.periodStartDay,
              onChanged: (day) async {
                await repo.putInt(SettingKeys.periodStartDay, day);
                ref.invalidate(openPeriodProvider);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(l.settingsOrganisation),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: Text(l.accounts),
                  subtitle: Text(l.accountsSub),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/accounts'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.event_repeat_outlined),
                  title: Text(l.recurringLabel),
                  subtitle: Text(l.recurringSub),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/recurrences'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: Text(l.categories),
                  subtitle: Text(l.categoriesSub),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/categories'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.handshake_outlined),
                  title: Text(l.debtsCredits),
                  subtitle: Text(l.debtsSub),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/debts'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(l.settingsNotifications),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: Text(l.dueReminders),
                  subtitle: Text(l.dueRemindersSub),
                  value: settings.notificationsEnabled,
                  onChanged: (v) async {
                    if (v) {
                      final granted = await NotificationService.instance
                          .requestPermission(l);
                      if (!context.mounted) return;
                      if (!granted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l.notificationsDenied)),
                        );
                        return;
                      }
                    }
                    await repo.putBool(
                      SettingKeys.notificationsEnabled,
                      value: v,
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.alarm_outlined),
                  title: Text(l.dailyReminder),
                  subtitle: Text(l.dailyReminderSub),
                  value: settings[SettingKeys.dailyReminder] == 'true',
                  onChanged: (v) async {
                    final service = NotificationService.instance;
                    if (v) {
                      final granted = await service.requestPermission(l);
                      if (!context.mounted) return;
                      if (!granted) return;
                      await service.scheduleDailyReminder(l);
                    } else {
                      await service.cancelDailyReminder();
                    }
                    await repo.putBool(SettingKeys.dailyReminder, value: v);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(l.settingsSecurity),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: Text(l.biometricLock),
              subtitle: Text(l.biometricLockSub),
              value: settings.biometricEnabled,
              onChanged: (v) async {
                if (v) {
                  final ok = await AuthService.instance.authenticate(
                    l.unlockReason,
                  );
                  if (!ok) return;
                }
                await repo.putBool(SettingKeys.biometricEnabled, value: v);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionTitle(l.settingsData),
          const _DataCard(),
        ],
      ),
    );
  }
}

/// Backup, restore and CSV import — the offline data-safety tools.
class _DataCard extends ConsumerWidget {
  const _DataCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final lastBackup = ref.watch(settingsProvider).value?.lastBackupAt;

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: Text(l.backup),
            subtitle: Text(
              lastBackup == null
                  ? l.backupNeverSub
                  : l.backupLastSub(
                      _ago(l, DateTime.now().difference(lastBackup)),
                    ),
            ),
            onTap: () => _backup(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: Text(l.restore),
            subtitle: Text(l.restoreSub),
            onTap: () => _restore(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.restart_alt,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(l.startOver),
            subtitle: Text(l.startOverSub),
            onTap: () => _resetAll(context, ref),
          ),
        ],
      ),
    );
  }

  static String _ago(L l, Duration d) => switch (d.inDays) {
    0 => l.agoToday,
    1 => l.agoYesterday,
    final days => l.agoDays(days),
  };

  Future<void> _resetAll(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final confirmed = await _confirm(context, l.resetAllTitle, l.resetAllBody);
    if (!confirmed) return;
    await ref.read(onboardingServiceProvider).resetAll();
    ref.invalidate(openPeriodProvider);
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final password = await _askPassword(context, l.backupPasswordTitle);
    if (password == null || password.isEmpty) return;
    try {
      await ref.read(backupServiceProvider).exportAndShare(l, password);
    } on Object catch (e) {
      if (context.mounted) _snack(context, l.backupFailed('$e'));
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final picked = await FilePicker.platform.pickFiles(withData: false);
    final path = picked?.files.single.path;
    if (path == null) return;
    if (!context.mounted) return;
    final password = await _askPassword(context, l.restorePasswordTitle);
    if (password == null || password.isEmpty || !context.mounted) return;
    final confirmed = await _confirm(context, l.restoreTitle, l.restoreBody);
    if (!confirmed) return;
    try {
      await ref.read(backupServiceProvider).restore(l, File(path), password);
      if (context.mounted) {
        _snack(context, l.restoreDone);
      }
    } on Object catch (e) {
      if (context.mounted) _snack(context, '$e');
    }
  }

  void _snack(BuildContext context, String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  Future<bool> _confirm(BuildContext context, String title, String body) async {
    final l = L.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.actionConfirm),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<String?> _askPassword(BuildContext context, String title) {
    final l = L.of(context);
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          obscureText: true,
          decoration: InputDecoration(labelText: l.password),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l.actionConfirm),
          ),
        ],
      ),
    );
  }
}

Future<void> _pickLanguage(BuildContext context, WidgetRef ref) async {
  final l = L.of(context);
  final options = [
    ('system', l.languageSystem),
    ('fr', l.languageFrench),
    ('en', l.languageEnglish),
  ];
  final code = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (value, label) in options)
            ListTile(
              title: Text(label),
              onTap: () => Navigator.pop(context, value),
            ),
        ],
      ),
    ),
  );
  if (code != null) {
    await ref.read(settingsRepositoryProvider).put(SettingKeys.language, code);
  }
}

Future<void> _pickCurrency(
  BuildContext context,
  WidgetRef ref,
  String current,
) async {
  final code = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text(L.of(context).pickCurrency),
          ),
          for (final entry in kCurrencies.entries)
            ListTile(
              title: Text('${entry.key} · ${entry.value}'),
              trailing: entry.key == current ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, entry.key),
            ),
        ],
      ),
    ),
  );
  if (code != null) {
    await ref.read(settingsRepositoryProvider).put(SettingKeys.currency, code);
  }
}

class _PeriodStartTile extends StatefulWidget {
  const _PeriodStartTile({required this.startDay, required this.onChanged});

  final int startDay;

  /// Called **once**, when the finger leaves the slider.
  final ValueChanged<int> onChanged;

  @override
  State<_PeriodStartTile> createState() => _PeriodStartTileState();
}

class _PeriodStartTileState extends State<_PeriodStartTile> {
  /// The value under the finger. Kept local so dragging repaints without
  /// touching the database: committing on every tick wrote the setting ~27
  /// times for one drag, and each write re-ran `ensureOpenPeriodFor`, which
  /// created a budget period for *every day the finger passed over*. The
  /// history screen then paged day by day instead of month by month.
  int? _dragging;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final day = _dragging ?? widget.startDay;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.periodStartsOn, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            day == 1 ? l.periodStartFirst : l.periodStartNth(day),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: day.toDouble(),
                  min: 1,
                  max: 28,
                  divisions: 27,
                  label: l.dayOrdinal(day),
                  onChanged: (v) => setState(() => _dragging = v.round()),
                  onChangeEnd: (v) {
                    setState(() => _dragging = null);
                    if (v.round() != widget.startDay) widget.onChanged(v.round());
                  },
                ),
              ),
              SizedBox(
                width: 44,
                child: Text(
                  l.dayOrdinal(day),
                  textAlign: TextAlign.end,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      left: AppSpacing.xs,
      bottom: AppSpacing.sm,
    ),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}
