import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/repositories/goal_repository.dart';
import 'package:budget/features/goals/add_goal_page.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/labels.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.savingsGoals)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AddGoalPage()),
        ),
        icon: const Icon(Icons.add),
        label: Text(l.goal),
      ),
      body: goals.when(
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
                children: [for (final g in list) _GoalCard(view: g)],
              ),
      ),
    );
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.view});

  final GoalView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final g = view.goal;

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
                  CircleAvatar(
                    backgroundColor: scheme.secondaryContainer,
                    foregroundColor: scheme.onSecondaryContainer,
                    child: Icon(iconFor(g.iconKey)),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g.name, style: theme.textTheme.titleMedium),
                        if (g.targetDate != null)
                          Text(
                            l.goalByDate(g.targetDate!.shortLabel),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (v) => switch (v) {
                      'archive' =>
                        ref.read(goalRepositoryProvider).archive(g.id),
                      _ => null,
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'archive',
                        child: Text(l.archive),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.full),
                child: LinearProgressIndicator(
                  value: view.ratio,
                  minHeight: 10,
                  backgroundColor: scheme.surfaceContainerHighest,
                  color: view.reached ? scheme.healthy : scheme.primary,
                  semanticsLabel: l.goalProgressOf(g.name),
                  semanticsValue: spokenPercent(l, view.ratio),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${view.saved.format()} / ${view.target.format()}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (view.reached)
                    Text(
                      l.goalReached,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.healthy,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else
                    Text(
                      l.goalRemaining(view.remaining.format()),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              if (g.monthlyPlannedCents > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.savings_outlined,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l.goalMonthlySetAside(Money(g.monthlyPlannedCents).format()),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.tonalIcon(
                  onPressed: () => _contribute(context, ref),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(l.actionAdd),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _contribute(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final controller = TextEditingController(
      text: view.goal.monthlyPlannedCents > 0
          ? (view.goal.monthlyPlannedCents / 100).toStringAsFixed(2)
          : '',
    );
    final amount = await showDialog<Money>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.addToGoal(view.goal.name)),
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
            child: Text(l.actionAdd),
          ),
        ],
      ),
    );
    controller.dispose();
    if (amount == null) return;

    final period = await ref.read(openPeriodProvider.future);
    await ref
        .read(goalRepositoryProvider)
        .contribute(
          goalId: view.goal.id,
          periodId: period.id,
          amountCents: amount.cents,
          date: DateTime.now(),
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
              Icons.savings_outlined,
              size: 56,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(l.noGoalsTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l.noGoalsBody,
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
