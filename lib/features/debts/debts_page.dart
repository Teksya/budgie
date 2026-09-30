import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/features/debts/add_debt_page.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/labels.dart';
import 'package:budget/shared/widgets/amount_text.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DebtsPage extends ConsumerWidget {
  const DebtsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final debts = ref.watch(debtsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.debtsCredits)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AddDebtPage()),
        ),
        icon: const Icon(Icons.add),
        label: Text(l.actionAdd),
      ),
      body: debts.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 4),
        ),
        error: (e, _) => Center(child: Text(l.errorWith('$e'))),
        data: (list) => list.isEmpty
            ? const _Empty()
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.xl * 4,
                ),
                children: [for (final d in list) _DebtCard(debt: d)],
              ),
      ),
    );
  }
}

class _DebtCard extends ConsumerWidget {
  const _DebtCard({required this.debt});

  final Debt debt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final lent = debt.kind == DebtKind.debtLent;
    final paid = Money(debt.principalCents - debt.remainingCents);
    final ratio = debt.principalCents == 0
        ? 0.0
        : paid.cents / debt.principalCents;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(debt.name, style: theme.textTheme.titleMedium),
                        Text(
                          debt.kind.label(l),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (debt.settled)
                    Chip(
                      label: Text(l.debtSettled),
                      backgroundColor: scheme.healthyContainer,
                      labelStyle: TextStyle(color: scheme.onHealthyContainer),
                    )
                  else
                    PopupMenuButton<String>(
                      onSelected: (v) => switch (v) {
                        'delete' =>
                          ref.read(debtRepositoryProvider).delete(debt.id),
                        _ => null,
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(l.actionDelete),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: ratio.clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: scheme.surfaceContainerHighest,
                  color: debt.settled ? scheme.healthy : scheme.primary,
                  semanticsLabel: l.debtRepaymentOf(debt.name),
                  semanticsValue: spokenPercent(l, ratio),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lent ? l.debtLeftToCollect : l.debtOutstanding,
                    style: theme.textTheme.bodyMedium,
                  ),
                  AmountText(
                    Money(debt.remainingCents),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (debt.installmentsTotal != null)
                Text(
                  l.debtInstalmentCount(
                        debt.installmentsPaid,
                        debt.installmentsTotal!,
                      ) +
                      (debt.installmentCents > 0
                          ? ' · ${l.perMonth(Money(debt.installmentCents).format())}'
                          : ''),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              if (!debt.settled) ...[
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.tonalIcon(
                    onPressed: () => _pay(context, ref),
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(lent ? l.debtRepaid : l.debtPayInstalment),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pay(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final suggested = debt.installmentCents > 0
        ? debt.installmentCents
        : debt.remainingCents;
    final controller = TextEditingController(
      text: (suggested / 100).toStringAsFixed(2),
    );
    final accountId = await ref.read(accountRepositoryProvider).defaultId();
    if (!context.mounted) return;

    final amount = await showDialog<Money>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.debtPaymentTitle(debt.name)),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
          ],
          decoration: InputDecoration(
            labelText: l.amount,
            suffixText: AppCurrency.instance.symbol,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () {
              final v = double.tryParse(
                controller.text.trim().replaceAll(',', '.'),
              );
              Navigator.pop(
                context,
                v == null || v <= 0 ? null : Money.fromEuros(v),
              );
            },
            child: Text(l.actionConfirm),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount == null || accountId == null) return;

    await ref
        .read(debtRepositoryProvider)
        .recordPayment(
          debt,
          amountCents: amount.cents,
          accountId: accountId,
        );
  }
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
              Icons.handshake_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.noDebtsTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.noDebtsBody,
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
