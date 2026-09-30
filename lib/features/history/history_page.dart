import 'dart:async';

import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/history_repository.dart';
import 'package:budget/data/repositories/transaction_repository.dart';
import 'package:budget/features/history/month_recap_page.dart';
import 'package:budget/l10n/app_localizations.dart';
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
    final l = L.of(context);
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
        title: Text(l.history),
        // BackButton, not a bare IconButton: it carries the localised
        // "Retour" tooltip and semantics that a raw arrow icon does not.
        leading: const BackButton(),
        actions: [
          IconButton(
            onPressed: selected == null
                ? null
                : () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => MonthRecapPage(period: selected),
                    ),
                  ),
            icon: const Icon(Icons.auto_awesome_outlined),
            tooltip: l.recapSeeMonth,
          ),
          IconButton(
            onPressed: selected == null
                ? null
                : () => unawaited(_export(context, ref, selected)),
            icon: const Icon(Icons.ios_share),
            tooltip: l.exportMonth,
          ),
        ],
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
              error: (e, _) => Center(child: Text(l.errorWith('$e'))),
              data: (s) =>
                  s == null ? const _NoData() : _PeriodDetail(summary: s),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _export(BuildContext context, WidgetRef ref, Period period) async {
  final l = L.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final exported = await ref
      .read(csvExportServiceProvider)
      .exportPeriod(l, period);
  if (!exported) {
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l.exportEmpty)));
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
    final l = L.of(context);
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
            tooltip: l.previousMonth,
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
            tooltip: l.nextMonth,
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
    final l = L.of(context);
    final txns =
        ref.watch(selectedPeriodTransactionsProvider).value ?? const [];

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
            Text(l.navTransactions, style: Theme.of(context).textTheme.titleMedium),
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
                l.noTransactionsThatMonth,
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
    final l = L.of(context);
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
            l.closingBalance,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: positive
                  ? scheme.onHealthyContainer
                  : scheme.onErrorContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AmountText(
            summary.closingBalance,
            signed: true,
            style: theme.textTheme.displaySmall?.copyWith(
              color: positive
                  ? scheme.onHealthyContainer
                  : scheme.onErrorContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l.carriedToNextMonth,
            style: theme.textTheme.bodySmall?.copyWith(
              color:
                  (positive
                          ? scheme.onHealthyContainer
                          : scheme.onErrorContainer)
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
    final l = L.of(context);
    return Card(
      child: Column(
        children: [
          _Line(
            label: l.carryInLabel,
            amount: summary.carryIn,
            signed: true,
            trailing: summary.isManualCarry ? l.carryCorrected : null,
          ),
          const Divider(height: 1),
          _Line(label: l.incomeReceived, amount: summary.incomeReceived),
          if (summary.incomePlanned.isPositive)
            _Line(
              label: l.incomePlanned,
              amount: summary.incomePlanned,
              faded: true,
            ),
          const Divider(height: 1),
          _Line(label: l.expenses, amount: -summary.expenses, signed: true),
          if (summary.pendingChargesCount > 0)
            _Line(
              label: l.unpaidCharges(summary.pendingChargesCount),
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
                    label: Text(l.fixCarry),
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
    final l = L.of(context);
    final controller = TextEditingController(
      text: (summary.carryIn.cents / 100).toStringAsFixed(2),
    );
    final result = await showDialog<Money?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.fixCarry),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.fixCarryBody),
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
              decoration: InputDecoration(
                labelText: l.carryShort,
                suffixText: AppCurrency.instance.symbol,
              ),
            ),
          ],
        ),
        actions: [
          if (summary.isManualCarry)
            TextButton(
              onPressed: () => Navigator.pop(context, Money.zero),
              child: Text(l.restoreAuto),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.actionCancel),
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
            child: Text(l.actionApply),
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
    final color = view.category != null
        ? Color(view.category!.colorValue)
        : scheme.primary;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.16),
        foregroundColor: color,
        child: Icon(iconFor(view.category?.iconKey), size: 20),
      ),
      title: Text(view.category?.name ?? L.of(context).uncategorized),
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

  /// Deleting from a past month reflows the carry-over of every later month,
  /// so the confirmation stays — but it is undoable all the same.
  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(transactionRepositoryProvider);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteTransactionQuestion),
        content: Text(l.deleteTransactionBody),
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
    if (!(ok ?? false)) return;

    final deleted = view.txn;
    await repo.delete(deleted);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l.transactionDeleted),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: l.actionUndo,
            onPressed: () => unawaited(repo.restore(deleted)),
          ),
        ),
      );
  }
}

class _NoData extends StatelessWidget {
  const _NoData();

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
              Icons.history_toggle_off,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.noDataTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.noDataBody,
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
