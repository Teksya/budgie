import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/features/debts/add_debt_page.dart';
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
    final debts = ref.watch(debtsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dettes & crédits')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AddDebtPage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
      body: debts.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 4),
        ),
        error: (e, _) => Center(child: Text('Erreur : $e')),
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
                          debt.kind.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (debt.settled)
                    Chip(
                      label: const Text('Soldé'),
                      backgroundColor: scheme.healthyContainer,
                      labelStyle: TextStyle(color: scheme.onHealthyContainer),
                    )
                  else
                    PopupMenuButton<String>(
                      onSelected: (v) => switch (v) {
                        'delete' => ref
                            .read(debtRepositoryProvider)
                            .delete(debt.id),
                        _ => null,
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Supprimer'),
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
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lent ? 'Reste à récupérer' : 'Capital restant dû',
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
                  '${debt.installmentsPaid} / ${debt.installmentsTotal} échéances'
                  '${debt.installmentCents > 0 ? ' · ${Money(debt.installmentCents).format()}/mois' : ''}',
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
                    label: Text(lent ? 'Remboursé' : 'Payer une échéance'),
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
    final suggested = debt.installmentCents > 0
        ? debt.installmentCents
        : debt.remainingCents;
    final controller = TextEditingController(
      text: (suggested / 100).toStringAsFixed(2),
    );
    final accounts = ref.read(accountsProvider).value ?? const [];
    final accountId = accounts.isNotEmpty ? accounts.first.id : null;

    final amount = await showDialog<Money>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Paiement · ${debt.name}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
          ],
          decoration: const InputDecoration(labelText: 'Montant', suffixText: '€'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
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
            child: const Text('Valider'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount == null || accountId == null) return;

    await ref.read(debtRepositoryProvider).recordPayment(
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
            Text('Aucune dette', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Suis tes crédits, tes paiements en plusieurs fois, ou '
              "l'argent qu'on te doit.",
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
