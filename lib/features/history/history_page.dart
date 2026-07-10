import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/history_repository.dart';
import 'package:budget/data/repositories/transaction_repository.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/widgets/amount_text.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(periodsProvider).value ?? const [];
    final selected = ref.watch(selectedPeriodProvider);
    final summary = ref.watch(periodSummaryProvider);

    // Index of the selected period inside the desc-sorted list.
    final index = selected == null
        ? 0
        : periods.indexWhere((p) => p.id == selected.id);
    final hasOlder = index >= 0 && index < periods.length - 1;
    final hasNewer = index > 0;

    void goTo(int newIndex) => ref
        .read(selectedPeriodStartProvider.notifier)
        .select(periods[newIndex].startDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Column(
        children: [
          _MonthNavigator(
            label: selected == null
                ? '—'
                : PeriodRange(selected.startDate, selected.endDate).label,
            onOlder: hasOlder ? () => goTo(index + 1) : null,
            onNewer: hasNewer ? () => goTo(index - 1) : null,
          ),
          Expanded(
            child: summary.when(
              loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 4),
        ),
              error: (e, _) => Center(child: Text('Erreur : $e')),
              data: (s) => s == null
                  ? const _NoData()
                  : _PeriodDetail(summary: s),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthNavigator extends StatelessWidget {
  const _MonthNavigator({
    required this.label,
    required this.onOlder,
    required this.onNewer,
  });

  final String label;
  final VoidCallback? onOlder;
  final VoidCallback? onNewer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton.filledTonal(
            onPressed: onOlder,
            icon: const Icon(Icons.chevron_left),
            tooltip: 'Mois précédent',
          ),
          Text(
            label,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton.filledTonal(
            onPressed: onNewer,
            icon: const Icon(Icons.chevron_right),
            tooltip: 'Mois suivant',
          ),
        ],
      ),
    );
  }
}

class _PeriodDetail extends ConsumerWidget {
  const _PeriodDetail({required this.summary});

  final PeriodSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txns = ref.watch(selectedPeriodTransactionsProvider).value ?? const [];

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      children: [
        _ClosingCard(summary: summary),
        const SizedBox(height: AppSpacing.md),
        _BreakdownCard(summary: summary),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Transactions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${txns.length}',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (txns.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Aucune transaction ce mois-là.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (final v in txns) ...[
                  if (v != txns.first) const Divider(height: 1, indent: 64),
                  _HistoryTxnTile(view: v),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ClosingCard extends StatelessWidget {
  const _ClosingCard({required this.summary});

  final PeriodSummary summary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final positive = !summary.closingBalance.isNegative;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: ShapeDecoration(
        shape: AppShapes.hero,
        color: positive ? scheme.healthyContainer : scheme.errorContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Solde de fin de mois',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: positive ? scheme.onHealthyContainer : scheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AmountText(
            summary.closingBalance,
            signed: true,
            style: theme.textTheme.displaySmall?.copyWith(
              color: positive ? scheme.onHealthyContainer : scheme.onErrorContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'reporté sur le mois suivant',
            style: theme.textTheme.bodySmall?.copyWith(
              color: (positive ? scheme.onHealthyContainer : scheme.onErrorContainer)
                  .withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownCard extends ConsumerWidget {
  const _BreakdownCard({required this.summary});

  final PeriodSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Column(
        children: [
          _Line(
            label: 'Report du mois précédent',
            amount: summary.carryIn,
            signed: true,
            trailing: summary.isManualCarry ? 'corrigé' : null,
          ),
          const Divider(height: 1),
          _Line(label: 'Revenus perçus', amount: summary.incomeReceived),
          if (summary.incomePlanned.isPositive)
            _Line(
              label: 'Revenus prévus',
              amount: summary.incomePlanned,
              faded: true,
            ),
          const Divider(height: 1),
          _Line(label: 'Dépenses', amount: -summary.expenses, signed: true),
          if (summary.pendingChargesCount > 0)
            _Line(
              label: 'Charges non payées (${summary.pendingChargesCount})',
              amount: -summary.unpaidCharges,
              signed: true,
              faded: true,
            ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editCarry(context, ref),
                    icon: const Icon(Icons.tune, size: 18),
                    label: const Text('Corriger le report'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editCarry(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(
      text: (summary.carryIn.cents / 100).toStringAsFixed(2),
    );
    final result = await showDialog<Money?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Corriger le report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Force le report entrant de ce mois. Les mois suivants sont '
              'recalculés en conséquence.',
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,-]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Report',
                suffixText: '€',
              ),
            ),
          ],
        ),
        actions: [
          if (summary.isManualCarry)
            TextButton(
              onPressed: () => Navigator.pop(context, Money.zero),
              child: const Text("Rétablir l'auto"),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final value = double.tryParse(
                controller.text.trim().replaceAll(',', '.'),
              );
              Navigator.pop(
                context,
                value == null ? null : Money.fromEuros(value),
              );
            },
            child: const Text('Appliquer'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result == null) return;
    // The "rétablir l'auto" button returns zero as a sentinel for "clear".
    final repo = ref.read(historyRepositoryProvider);
    await repo.setManualCarryOver(
      summary.period.id,
      summary.isManualCarry && result == Money.zero ? null : result,
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.label,
    required this.amount,
    this.signed = false,
    this.faded = false,
    this.trailing,
  });

  final String label;
  final Money amount;
  final bool signed;
  final bool faded;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = faded ? theme.colorScheme.onSurfaceVariant : null;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + 2,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(color: color),
            ),
          ),
          if (trailing != null) ...[
            Text(
              trailing!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
          AmountText(
            amount,
            signed: signed,
            style: theme.textTheme.bodyLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _HistoryTxnTile extends ConsumerWidget {
  const _HistoryTxnTile({required this.view});

  final TxnView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final txn = view.txn;
    final isIncome = txn.type == TxnType.income;
    final color =
        view.category != null ? Color(view.category!.colorValue) : scheme.primary;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.16),
        foregroundColor: color,
        child: Icon(iconFor(view.category?.iconKey), size: 20),
      ),
      title: Text(view.category?.name ?? 'Non catégorisé'),
      subtitle: Text(txn.date.shortLabel),
      trailing: AmountText(
        isIncome ? Money(txn.amountCents) : -Money(txn.amountCents),
        signed: true,
        colorBySign: isIncome,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      onLongPress: () => _confirmDelete(context, ref),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette transaction ?'),
        content: const Text(
          'Le solde de ce mois et le report des mois suivants seront recalculés.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (ok ?? false) {
      await ref.read(transactionRepositoryProvider).delete(view.txn);
    }
  }
}

class _NoData extends StatelessWidget {
  const _NoData();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_toggle_off,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Aucune donnée', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Les mois passés apparaîtront ici au fil du temps.',
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
