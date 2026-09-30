import 'dart:async';

import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/transaction_repository.dart';
import 'package:budget/features/transactions/add_transaction_page.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/widgets/amount_text.dart';
import 'package:budget/shared/widgets/expressive_fab.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum _TxnFilter { all, expense, income }

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  final _search = TextEditingController();
  _TxnFilter _filter = _TxnFilter.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<TxnView> _apply(List<TxnView> list) {
    final q = _search.text;
    return list.where((v) {
      if (_filter == _TxnFilter.expense && v.txn.type != TxnType.expense) {
        return false;
      }
      if (_filter == _TxnFilter.income && v.txn.type != TxnType.income) {
        return false;
      }
      return v.matches(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final txns = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.navTransactions),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Column(
              children: [
                SearchBar(
                  controller: _search,
                  hintText: l.searchHint,
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_search.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: l.clearSearch,
                        onPressed: () => setState(_search.clear),
                      ),
                  ],
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    for (final (filter, label) in [
                      (_TxnFilter.all, l.filterAll),
                      (_TxnFilter.expense, l.expenses),
                      (_TxnFilter.income, l.income),
                    ]) ...[
                      ChoiceChip(
                        label: Text(label),
                        selected: _filter == filter,
                        onSelected: (_) => setState(() => _filter = filter),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ExpressiveFab(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: l.actionAdd,
      ),
      body: txns.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 5),
        ),
        error: (e, _) => Center(child: Text(l.errorWith('$e'))),
        data: (all) {
          if (all.isEmpty) return const _EmptyState();
          final list = _apply(all);
          if (list.isEmpty) return const _NoMatch();
          final byDay = groupBy(
            list,
            (v) => DateTime(v.txn.date.year, v.txn.date.month, v.txn.date.day),
          );
          final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.xl * 3,
            ),
            itemCount: days.length,
            itemBuilder: (context, i) {
              final day = days[i];
              final rows = byDay[day]!;
              return _DaySection(day: day, rows: rows);
            },
          );
        },
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({required this.day, required this.rows});

  final DateTime day;
  final List<TxnView> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayTotal = rows
        .map(
          (r) => r.txn.type == TxnType.income
              ? Money(r.txn.amountCents)
              : -Money(r.txn.amountCents),
        )
        .sum;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                day.longDayLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              AmountText(
                dayTotal,
                signed: true,
                colorBySign: true,
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
        ),
        Card(
          child: Column(
            children: [
              for (final row in rows) ...[
                if (row != rows.first)
                  const Divider(
                    height: 1,
                    indent: 64,
                    endIndent: AppSpacing.md,
                  ),
                _TxnTile(row: row),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TxnTile extends ConsumerWidget {
  const _TxnTile({required this.row});

  final TxnView row;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final scheme = Theme.of(context).colorScheme;
    final txn = row.txn;
    final isIncome = txn.type == TxnType.income;
    final isTransfer = txn.type == TxnType.transfer;
    final color = isTransfer
        ? scheme.onSurfaceVariant
        : row.category != null
        ? Color(row.category!.colorValue)
        : scheme.primary;

    final planned = isIncome && txn.incomeStatus == IncomeStatus.planned;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.16),
        foregroundColor: color,
        child: Icon(
          isTransfer ? Icons.swap_horiz : iconFor(row.category?.iconKey),
          size: 20,
        ),
      ),
      title: Text(
        isTransfer ? l.moveLabel : (row.category?.name ?? l.uncategorized),
      ),
      subtitle: Text(
        [
          if (isTransfer) l.betweenAccounts,
          if (txn.note != null && txn.note!.isNotEmpty) txn.note!,
          if (planned) l.plannedTapToReceive,
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: isTransfer
          ? Text(
              Money(txn.amountCents).format(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          : AmountText(
              isIncome ? Money(txn.amountCents) : -Money(txn.amountCents),
              signed: true,
              colorBySign: isIncome,
              style: Theme.of(context).textTheme.titleMedium,
            ),
      onTap: () => planned
          ? _editIncome(context, ref)
          : openTransactionEditor(context, txn),
      onLongPress: () => unawaited(_showActions(context, ref)),
    );
  }

  /// Long press used to delete on the spot behind a yes/no dialog. A sheet
  /// gives duplicating — by far the more common intent — somewhere to live,
  /// and the deletion below is undoable, so it no longer needs a gate.
  Future<void> _showActions(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: Text(l.duplicateToday),
              onTap: () {
                Navigator.pop(sheet);
                unawaited(_duplicate(context, ref));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Theme.of(sheet).colorScheme.error,
              ),
              title: Text(l.actionDelete),
              onTap: () {
                Navigator.pop(sheet);
                unawaited(_deleteWithUndo(context, ref));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _duplicate(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final period = await ref.read(openPeriodProvider.future);
    await ref
        .read(transactionRepositoryProvider)
        .duplicate(row.txn, periodId: period.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l.duplicated),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  Future<void> _deleteWithUndo(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final repo = ref.read(transactionRepositoryProvider);
    final deleted = row.txn;

    await repo.delete(deleted);
    // Replace rather than queue: deleting three rows in a row used to stack
    // three banners, each waiting out its own timer over the bottom bar.
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

  Future<void> _editIncome(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final txn = row.txn;
    final controller = TextEditingController(
      text: (txn.amountCents / 100).toStringAsFixed(2),
    );
    var received = txn.incomeStatus == IncomeStatus.received;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(row.category?.name ?? l.income),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: l.amount,
                  suffixText: AppCurrency.instance.symbol,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l.alreadyReceived),
                value: received,
                onChanged: (v) => setState(() => received = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.actionSave),
            ),
          ],
        ),
      ),
    );

    if (saved ?? false) {
      final value =
          double.tryParse(controller.text.trim().replaceAll(',', '.')) ?? 0;
      await ref
          .read(transactionRepositoryProvider)
          .editAmountAndStatus(
            txn,
            amountCents: Money.fromEuros(value).cents,
            incomeStatus: received
                ? IncomeStatus.received
                : IncomeStatus.planned,
          );
    }
    controller.dispose();
  }

}

class _NoMatch extends StatelessWidget {
  const _NoMatch();

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
              Icons.search_off,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(L.of(context).noResults, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

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
              Icons.receipt_long_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              L.of(context).noTransactionsThisMonth,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              L.of(context).noTransactionsBody,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => context.push('/add'),
              icon: const Icon(Icons.add),
              label: Text(L.of(context).actionAdd),
            ),
          ],
        ),
      ),
    );
  }
}
