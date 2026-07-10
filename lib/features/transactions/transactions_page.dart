import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/transaction_repository.dart';
import 'package:budget/features/transactions/add_transaction_page.dart';
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
    final q = _search.text.trim().toLowerCase();
    return list.where((v) {
      if (_filter == _TxnFilter.expense && v.txn.type != TxnType.expense) {
        return false;
      }
      if (_filter == _TxnFilter.income && v.txn.type != TxnType.income) {
        return false;
      }
      if (q.isEmpty) return true;
      final note = v.txn.note?.toLowerCase() ?? '';
      final cat = v.category?.name.toLowerCase() ?? '';
      return note.contains(q) || cat.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final txns = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
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
                  hintText: 'Rechercher…',
                  leading: const Icon(Icons.search),
                  trailing: [
                    if (_search.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(_search.clear),
                      ),
                  ],
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    for (final (filter, label) in const [
                      (_TxnFilter.all, 'Tout'),
                      (_TxnFilter.expense, 'Dépenses'),
                      (_TxnFilter.income, 'Revenus'),
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
        label: 'Ajouter',
      ),
      body: txns.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 5),
        ),
        error: (e, _) => Center(child: Text('Erreur : $e')),
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
    final scheme = Theme.of(context).colorScheme;
    final txn = row.txn;
    final isIncome = txn.type == TxnType.income;
    final isTransfer = txn.type == TxnType.transfer;
    final color = isTransfer
        ? scheme.onSurfaceVariant
        : row.category != null
        ? Color(row.category!.colorValue)
        : scheme.primary;

    final planned =
        isIncome && txn.incomeStatus == IncomeStatus.planned;

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
        isTransfer
            ? 'Basculement'
            : (row.category?.name ?? 'Non catégorisé'),
      ),
      subtitle: Text(
        [
          if (isTransfer) 'entre comptes',
          if (txn.note != null && txn.note!.isNotEmpty) txn.note!,
          if (planned) 'prévu — appuie pour encaisser',
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
      onLongPress: () => _confirmDelete(context, ref),
    );
  }

  Future<void> _editIncome(BuildContext context, WidgetRef ref) async {
    final txn = row.txn;
    final controller = TextEditingController(
      text: (txn.amountCents / 100).toStringAsFixed(2),
    );
    var received = txn.incomeStatus == IncomeStatus.received;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(row.category?.name ?? 'Revenu'),
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
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  suffixText: '€',
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Déjà perçu'),
                value: received,
                onChanged: (v) => setState(() => received = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );

    if (saved ?? false) {
      final value =
          double.tryParse(controller.text.trim().replaceAll(',', '.')) ?? 0;
      await ref.read(transactionRepositoryProvider).editAmountAndStatus(
        txn,
        amountCents: Money.fromEuros(value).cents,
        incomeStatus:
            received ? IncomeStatus.received : IncomeStatus.planned,
      );
    }
    controller.dispose();
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette transaction ?'),
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
      await ref.read(transactionRepositoryProvider).delete(row.txn);
    }
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
            Text('Aucun résultat', style: theme.textTheme.titleMedium),
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
            Text('Aucune transaction ce mois-ci', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Appuie sur + pour ajouter ta première dépense ou ton salaire.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: () => context.push('/add'),
              icon: const Icon(Icons.add),
              label: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
