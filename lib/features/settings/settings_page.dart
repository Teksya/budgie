import 'dart:io';

import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/data/repositories/settings_repository.dart';
import 'package:budget/domain/services/auth_service.dart';
import 'package:budget/domain/services/notification_service.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value ?? const {};
    final repo = ref.watch(settingsRepositoryProvider);
    final themeMode = settings[SettingKeys.themeMode] ?? 'system';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réglages'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          const _SectionTitle('Apparence'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: const Text('Thème'),
                  subtitle: Text(switch (themeMode) {
                    'light' => 'Clair',
                    'dark' => 'Sombre',
                    _ => 'Système',
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
                  title: const Text('Couleurs dynamiques'),
                  subtitle: const Text(
                    "S'adapte au fond d'écran (Material You)",
                  ),
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
          const _SectionTitle('Général'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(L.of(context).settingsLanguage),
                  subtitle: Text(switch (settings[SettingKeys.language]) {
                    'fr' => L.of(context).languageFrench,
                    'en' => L.of(context).languageEnglish,
                    _ => L.of(context).languageSystem,
                  }),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickLanguage(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.euro_outlined),
                  title: Text(L.of(context).settingsCurrency),
                  subtitle: Text(
                    '${settings.currency} · '
                    '${kCurrencies[settings.currency] ?? ''}',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickCurrency(context, ref, settings.currency),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionTitle('Période budgétaire'),
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
          const _SectionTitle('Organisation'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet_outlined),
                  title: const Text('Comptes'),
                  subtitle: const Text('Courant, épargne, espèces'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/accounts'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.event_repeat_outlined),
                  title: const Text('Charges & revenus récurrents'),
                  subtitle: const Text('Loyer, abonnements, salaire…'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/recurrences'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.category_outlined),
                  title: const Text('Catégories'),
                  subtitle: const Text('Créer, renommer, couleur et icône'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/categories'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.handshake_outlined),
                  title: const Text('Dettes & crédits'),
                  subtitle: const Text('Crédits, paiements en plusieurs fois'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/debts'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionTitle('Notifications'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text("Rappels d'échéance"),
                  subtitle: const Text(
                    'Un rappel 3 jours avant et le jour même de chaque charge',
                  ),
                  value: settings.notificationsEnabled,
                  onChanged: (v) async {
                    if (v) {
                      final granted = await NotificationService.instance
                          .requestPermission();
                      if (!context.mounted) return;
                      if (!granted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Autorise les notifications dans les réglages '
                              'Android.',
                            ),
                          ),
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
                  title: const Text('Rappel quotidien de saisie'),
                  subtitle: const Text(
                    'Chaque soir à 20 h, « pense à noter tes dépenses »',
                  ),
                  value: settings[SettingKeys.dailyReminder] == 'true',
                  onChanged: (v) async {
                    final service = NotificationService.instance;
                    if (v) {
                      final granted = await service.requestPermission();
                      if (!context.mounted) return;
                      if (!granted) return;
                      await service.scheduleDailyReminder();
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
          const _SectionTitle('Sécurité'),
          Card(
            child: SwitchListTile(
              secondary: const Icon(Icons.fingerprint),
              title: const Text('Verrouillage biométrique'),
              subtitle: const Text(
                "Empreinte ou code de l'appareil à l'ouverture",
              ),
              value: settings.biometricEnabled,
              onChanged: (v) async {
                if (v) {
                  final ok = await AuthService.instance.authenticate();
                  if (!ok) return;
                }
                await repo.putBool(SettingKeys.biometricEnabled, value: v);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionTitle('Données'),
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
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Sauvegarder'),
            subtitle: const Text('Fichier chiffré par mot de passe'),
            onTap: () => _backup(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restore_outlined),
            title: const Text('Restaurer'),
            subtitle: const Text('Remplace les données actuelles'),
            onTap: () => _restore(context, ref),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(
              Icons.restart_alt,
              color: Theme.of(context).colorScheme.error,
            ),
            title: const Text('Repartir de zéro'),
            subtitle: const Text('Efface tout et relance la configuration'),
            onTap: () => _resetAll(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _resetAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await _confirm(
      context,
      'Tout effacer ?',
      'Toutes tes données seront supprimées et tu recommenceras la '
          'configuration de départ. Cette action est irréversible.',
    );
    if (!confirmed) return;
    await ref.read(onboardingServiceProvider).resetAll();
    ref.invalidate(openPeriodProvider);
  }

  Future<void> _backup(BuildContext context, WidgetRef ref) async {
    final password = await _askPassword(context, 'Mot de passe de la sauvegarde');
    if (password == null || password.isEmpty) return;
    try {
      await ref.read(backupServiceProvider).exportAndShare(password);
    } on Object catch (e) {
      if (context.mounted) _snack(context, 'Échec de la sauvegarde : $e');
    }
  }

  Future<void> _restore(BuildContext context, WidgetRef ref) async {
    final picked = await FilePicker.platform.pickFiles(withData: false);
    final path = picked?.files.single.path;
    if (path == null) return;
    if (!context.mounted) return;
    final password = await _askPassword(context, 'Mot de passe du fichier');
    if (password == null || password.isEmpty || !context.mounted) return;
    final confirmed = await _confirm(
      context,
      'Restaurer ?',
      'Toutes les données actuelles seront remplacées.',
    );
    if (!confirmed) return;
    try {
      await ref.read(backupServiceProvider).restore(File(path), password);
      if (context.mounted) {
        _snack(context, "Restauration réussie. Redémarre l'app.");
      }
    } on Object catch (e) {
      if (context.mounted) _snack(context, '$e');
    }
  }

  void _snack(BuildContext context, String message) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(message)));

  Future<bool> _confirm(BuildContext context, String title, String body) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<String?> _askPassword(BuildContext context, String title) {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Mot de passe'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Valider'),
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
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.sm,
              AppSpacing.lg,
              AppSpacing.sm,
            ),
            child: Text('Choisis ta devise'),
          ),
          for (final entry in kCurrencies.entries)
            ListTile(
              title: Text('${entry.key} · ${entry.value}'),
              trailing: entry.key == current
                  ? const Icon(Icons.check)
                  : null,
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

class _PeriodStartTile extends StatelessWidget {
  const _PeriodStartTile({required this.startDay, required this.onChanged});

  final int startDay;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Le mois budgétaire commence le', style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.xs),
          Text(
            startDay == 1
                ? 'le 1er de chaque mois'
                : 'le $startDay de chaque mois (utile si ton salaire tombe en fin de mois)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: startDay.toDouble(),
                  min: 1,
                  max: 28,
                  divisions: 27,
                  label: 'le $startDay',
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
              SizedBox(
                width: 44,
                child: Text(
                  'le $startDay',
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
