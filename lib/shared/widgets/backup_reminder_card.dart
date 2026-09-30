import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/data/repositories/settings_repository.dart';
import 'package:budget/domain/services/backup_reminder.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Nudges the user to make an encrypted backup once their data has gone
/// [kBackupReminderDays] without one. Renders nothing until then.
///
/// The data never leaves the phone, so a lost phone means lost data unless the
/// user exports a file — this is the only thing standing between them and that.
class BackupReminderCard extends ConsumerWidget {
  const BackupReminderCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(backupReminderDueProvider)) return const SizedBox.shrink();

    final settings = ref.watch(settingsProvider).value;
    final start = settings?.backupClockStart;
    if (settings == null || start == null) return const SizedBox.shrink();

    final l = L.of(context);
    final scheme = Theme.of(context).colorScheme;
    final days = DateTime.now().difference(start).inDays;
    final message = settings.lastBackupAt == null
        ? l.backupNudgeNever
        : l.backupNudgeDays(days);

    return Card(
      color: scheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: scheme.onSecondaryContainer,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.backupNudgeTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: scheme.onSecondaryContainer,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSecondaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Wrap, not Row: at large text scales the two buttons no longer fit
            // side by side and would overflow.
            Align(
              alignment: Alignment.centerRight,
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  TextButton(
                    onPressed: () => _snooze(ref),
                    child: Text(l.actionLater),
                  ),
                  FilledButton.icon(
                    onPressed: () => context.push('/settings'),
                    icon: const Icon(Icons.backup_outlined),
                    label: Text(l.backup),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _snooze(WidgetRef ref) => ref
      .read(settingsRepositoryProvider)
      .putDate(
        SettingKeys.backupReminderSnoozedUntil,
        DateTime.now().add(const Duration(days: kBackupSnoozeDays)),
      );
}
