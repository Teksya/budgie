import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/envelope_repository.dart';
import 'package:budget/features/envelopes/add_envelope_page.dart';
import 'package:budget/features/goals/goals_page.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/widgets/amount_text.dart';
import 'package:budget/shared/widgets/expressive_fab.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ChargesPage extends ConsumerWidget {
  const ChargesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charges = ref.watch(chargesProvider);
    final range = ref.watch(currentPeriodRangeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.md,
                bottom: AppSpacing.sm,
              ),
              child: Text(
                range.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: ExpressiveFab(
        onPressed: () => context.push('/charges/add'),
        icon: const Icon(Icons.add),
        label: 'Charge fixe',
      ),
      body: charges.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 4),
        ),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (list) {
          final unpaid = list
              .where((c) => c.status != InstanceStatus.paid)
              .toList()
            ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
          final paid =
              list.where((c) => c.status == InstanceStatus.paid).toList();

          final totalDue = unpaid
              .map((c) => Money(c.actualAmountCents ?? c.estimatedAmountCents))
              .sum;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.xl * 4,
            ),
            children: [
              _SummaryCard(totalDue: totalDue, count: unpaid.length),
              const SizedBox(height: AppSpacing.lg),
              const _HubGrid(),
              const SizedBox(height: AppSpacing.lg),
              const _EnvelopesSection(),
              const SizedBox(height: AppSpacing.lg),
              if (list.isEmpty)
                const _EmptyCharges()
              else ...[
                if (unpaid.isNotEmpty) ...[
                  const _Header(title: 'À payer'),
                  Card(
                    child: Column(
                      children: [
                        for (final c in unpaid) ...[
                          if (c != unpaid.first) const Divider(height: 1),
                          _ChargeTile(instance: c),
                        ],
                      ],
                    ),
                  ),
                ],
                if (paid.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  const _Header(title: 'Payées'),
                  Card(
                    child: Column(
                      children: [
                        for (final c in paid) ...[
                          if (c != paid.first) const Divider(height: 1),
                          _ChargeTile(instance: c),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.totalDue, required this.count});

  final Money totalDue;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: ShapeDecoration(
        shape: AppShapes.hero,
        color: scheme.secondaryContainer,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reste à payer ce mois-ci',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSecondaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  totalDue.format(),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: scheme.onSecondaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Text(
            count > 0 ? '$count' : '✓',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: scheme.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChargeTile extends ConsumerWidget {
  const _ChargeTile({required this.instance});

  final RecurrenceInstance instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final isPaid = instance.status == InstanceStatus.paid;
    final amount = Money(instance.actualAmountCents ?? instance.estimatedAmountCents);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isPaid
            ? scheme.healthyContainer
            : scheme.surfaceContainerHighest,
        foregroundColor: isPaid ? scheme.healthy : scheme.onSurfaceVariant,
        child: Icon(isPaid ? Icons.check : Icons.event_outlined, size: 20),
      ),
      title: Text(instance.label),
      subtitle: Text(
        isPaid
            ? 'payée le ${instance.paidDate?.shortLabel ?? ''}'
            : 'échéance le ${instance.dueDate.shortLabel}',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AmountText(amount, style: Theme.of(context).textTheme.titleMedium),
          Text(
            isPaid ? 'Annuler' : 'Payer',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: scheme.primary,
            ),
          ),
        ],
      ),
      onTap: () => isPaid
          ? ref.read(chargeRepositoryProvider).markUnpaid(instance)
          : _payDialog(context, ref),
    );
  }

  Future<void> _payDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController(
      text: (instance.estimatedAmountCents / 100).toStringAsFixed(2),
    );
    final accounts = ref.read(accountsProvider).value ?? const [];
    final accountId = accounts.isNotEmpty ? accounts.first.id : null;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payer « ${instance.label} »'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
          ],
          decoration: const InputDecoration(
            labelText: 'Montant réel',
            suffixText: '€',
          ),
        ),
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

    if ((confirmed ?? false) && accountId != null) {
      final value =
          double.tryParse(controller.text.trim().replaceAll(',', '.')) ?? 0;
      await ref.read(chargeRepositoryProvider).markPaid(
        instance,
        actualAmountCents: Money.fromEuros(value).cents,
        accountId: accountId,
      );
    }
    controller.dispose();
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

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

/// Discoverable entry points to the sub-sections that used to hide behind
/// app-bar icons — this is the "everything is findable" fix.
class _HubGrid extends StatelessWidget {
  const _HubGrid();

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, VoidCallback)>[
      (
        Icons.savings_outlined,
        "Objectifs d'épargne",
        () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const GoalsPage()),
        ),
      ),
      (
        Icons.event_repeat_outlined,
        'Charges récurrentes',
        () => context.push('/recurrences'),
      ),
      (
        Icons.handshake_outlined,
        'Dettes & crédits',
        () => context.push('/debts'),
      ),
      (
        Icons.add_card_outlined,
        'Revenu récurrent',
        () => context.push('/charges/add?type=income'),
      ),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 2.6,
      children: [
        for (final (icon, label, onTap) in items)
          _HubCard(icon: icon, label: label, onTap: onTap),
      ],
    );
  }
}

class _HubCard extends StatelessWidget {
  const _HubCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(icon, color: scheme.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EnvelopesSection extends ConsumerWidget {
  const _EnvelopesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final envelopes = ref.watch(envelopesProvider).value ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Enveloppes', style: theme.textTheme.titleMedium),
              TextButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const AddEnvelopePage(),
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Enveloppe'),
              ),
            ],
          ),
        ),
        if (envelopes.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                'Fixe un plafond mensuel par catégorie (ex. Courses : 300 €) '
                'pour suivre tes dépenses et être alerté avant de déraper.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (final e in envelopes) ...[
                  if (e != envelopes.first) const Divider(height: 1),
                  _EnvelopeTile(envelope: e),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _EnvelopeTile extends ConsumerWidget {
  const _EnvelopeTile({required this.envelope});

  final EnvelopeView envelope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final e = envelope;
    final barColor = e.isOver
        ? scheme.danger
        : e.isNear
        ? scheme.caution
        : Color(e.category.colorValue);

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => AddEnvelopePage(
            initialCategoryId: e.category.id,
            initialLimitCents: e.budget.limitCents,
          ),
        ),
      ),
      onLongPress: () => _confirmDelete(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  iconFor(e.category.iconKey),
                  size: 20,
                  color: Color(e.category.colorValue),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(e.category.name, style: theme.textTheme.bodyLarge),
                ),
                Text(
                  '${e.spent.formatRounded()} / ${e.limit.formatRounded()}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: e.isOver ? scheme.danger : scheme.onSurfaceVariant,
                    fontWeight: e.isOver ? FontWeight.w700 : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: e.ratio,
                minHeight: 8,
                backgroundColor: scheme.surfaceContainerHighest,
                color: barColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              e.isOver
                  ? 'Dépassé de ${(e.spent - e.limit).format()}'
                  : 'Reste ${e.remaining.format()}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: e.isOver
                    ? scheme.danger
                    : e.isNear
                    ? scheme.caution
                    : scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Supprimer l'enveloppe « ${envelope.category.name} » ?"),
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
      await ref.read(envelopeRepositoryProvider).delete(envelope.budget.id);
    }
  }
}

class _EmptyCharges extends StatelessWidget {
  const _EmptyCharges();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Icon(
              Icons.event_repeat_outlined,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Aucune charge fixe', style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              "Ajoute ton loyer, l'électricité, l'eau, internet… "
              'Elles apparaîtront chaque mois automatiquement.',
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
