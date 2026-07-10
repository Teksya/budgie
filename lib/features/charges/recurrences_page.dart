import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/features/charges/add_charge_page.dart';
import 'package:budget/features/charges/charge_history_page.dart';
import 'package:budget/shared/labels.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecurrencesPage extends ConsumerWidget {
  const RecurrencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recurrences = ref.watch(recurrencesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Charges & revenus récurrents')),
      body: recurrences.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 4),
        ),
        error: (e, _) => Center(child: Text('Erreur : $e')),
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
                const _Header('Revenus récurrents'),
                Card(child: Column(children: [for (final r in incomes) _Row(r: r)])),
                const SizedBox(height: AppSpacing.lg),
              ],
              if (charges.isNotEmpty) ...[
                const _Header('Charges fixes & abonnements'),
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final subtitle = [
      Money(r.estimatedAmountCents).format(),
      r.frequency.label.toLowerCase(),
      if (r.isVariable) 'variable',
      if (!r.active) 'désactivé',
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
            const PopupMenuItem(value: 'edit', child: Text('Modifier')),
            if (r.isVariable)
              const PopupMenuItem(
                value: 'history',
                child: Text('Historique & moyenne'),
              ),
            PopupMenuItem(
              value: 'toggle',
              child: Text(r.active ? 'Désactiver' : 'Activer'),
            ),
            const PopupMenuItem(value: 'delete', child: Text('Supprimer')),
          ],
        ),
        onTap: () => openRecurrenceEditor(context, r),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer « ${r.name} » ?'),
        content: const Text(
          'La récurrence ne générera plus de nouvelles échéances. '
          'Les échéances déjà créées ce mois-ci restent.',
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

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          'Aucune récurrence.\nAjoute une charge fixe ou un salaire depuis '
          "l'onglet Budgets.",
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
