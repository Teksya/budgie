import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/features/charges/add_charge_page.dart';
import 'package:budget/features/charges/charge_history_page.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/labels.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurrencesPage extends ConsumerWidget {
  const RecurrencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final recurrences = ref.watch(recurrencesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.recurringLabel)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openNewRecurrence(context),
        icon: const Icon(Icons.add),
        label: Text(l.actionAdd),
      ),
      body: recurrences.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 4),
        ),
        error: (e, _) => Center(child: Text(l.errorWith('$e'))),
        data: (all) {
          if (all.isEmpty) return const _Empty();
          final charges =
              all.where((r) => r.type == TxnType.expense).toList();
          final incomes = all.where((r) => r.type == TxnType.income).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            children: [
              if (incomes.isNotEmpty) ...[
                _Header(l.recurringIncomes),
                Card(child: Column(children: [for (final r in incomes) _Row(r: r)])),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (charges.isNotEmpty) ...[
                _Header(l.recurringCharges),
                Card(child: Column(children: [for (final r in charges) _Row(r: r)])),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Row extends ConsumerWidget {
  const _Row({required this.r});

  final Recurrence r;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final subtitle = [
      Money(r.estimatedAmountCents).format(),
      r.frequency.label(l).toLowerCase(),
      if (r.isVariable) l.recurrenceVariable,
      if (!r.active) l.recurrenceDisabled,
    ].join(' · ');

    return Opacity(
      opacity: r.active ? 1 : 0.5,
      child: ListTile(
        leading: Icon(
          r.type == TxnType.income
              ? Icons.north_east
              : Icons.event_repeat_outlined,
          color: r.type == TxnType.income ? scheme.healthy : scheme.primary,
        ),
        title: Text(r.name),
        subtitle: Text(subtitle),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => switch (value) {
            'edit' => openRecurrenceEditor(context, r),
            'history' => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => ChargeHistoryPage(recurrence: r),
              ),
            ),
            'toggle' => ref
                .read(recurrenceRepositoryProvider)
                .setActive(r.id, active: !r.active),
            'delete' => _confirmDelete(context, ref),
            _ => null,
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text(l.edit)),
            if (r.isVariable)
              PopupMenuItem(
                value: 'history',
                child: Text(l.historyAndAverage),
              ),
            PopupMenuItem(
              value: 'toggle',
              child: Text(r.active ? l.disable : l.enable),
            ),
            PopupMenuItem(value: 'delete', child: Text(l.actionDelete)),
          ],
        ),
        onTap: () => openRecurrenceEditor(context, r),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteNamedQuestion(r.name)),
        content: Text(l.deleteRecurrenceWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.actionDelete),
          ),
        ],
      ),
    );
    if (ok ?? false) {
      await ref.read(recurrenceRepositoryProvider).delete(r.id);
    }
  }
}

class _Header extends StatelessWidget {
  const _Header(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      left: AppSpacing.xs,
      bottom: AppSpacing.sm,
    ),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}

/// Opens the editor for a brand-new recurrence, asking which kind first.
Future<void> openNewRecurrence(BuildContext context) async {
  final l = L.of(context);
  final income = await showModalBottomSheet<bool>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.event_repeat_outlined),
            title: Text(l.fixedCharge),
            subtitle: Text(l.chargeNameHint),
            onTap: () => Navigator.pop(sheet, false),
          ),
          ListTile(
            leading: const Icon(Icons.add_card_outlined),
            title: Text(l.recurringIncome),
            subtitle: Text(l.incomeNameHint),
            onTap: () => Navigator.pop(sheet, true),
          ),
        ],
      ),
    ),
  );
  if (income == null || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => AddChargePage(income: income)),
  );
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_repeat_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.noRecurrencesTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.noRecurrencesBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
