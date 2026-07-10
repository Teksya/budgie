import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/motion.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/transaction_repository.dart';
import 'package:budget/domain/services/budget_engine.dart';
import 'package:budget/features/favorites/favorites_bar.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/widgets/amount_text.dart';
import 'package:budget/shared/widgets/expressive_fab.dart';
import 'package:budget/shared/widgets/fade_slide_in.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(currentPeriodRangeProvider);
    final snapshot = ref.watch(snapshotProvider);
    final charges = ref.watch(chargesProvider);
    final txns = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(L.of(context).appTitle),
        actions: [
          IconButton(
            onPressed: () => context.push('/history'),
            icon: const Icon(Icons.history),
            tooltip: L.of(context).history,
          ),
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: L.of(context).settingsTitle,
          ),
        ],
      ),
      floatingActionButton: ExpressiveFab(
        onPressed: () => context.push('/add'),
        icon: const Icon(Icons.add),
        label: L.of(context).actionAdd,
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(openPeriodProvider),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.xl * 3,
          ),
          children: [
            FadeSlideIn(
              child: snapshot.when(
                loading: () => const _RemainingSkeleton(),
                error: (e, _) => _ErrorCard(message: '$e'),
                data: (s) =>
                    _RemainingCard(snapshot: s, periodLabel: range.label),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const FadeSlideIn(
              delay: Duration(milliseconds: 55),
              child: FavoritesBar(),
            ),
            const SizedBox(height: AppSpacing.lg),
            FadeSlideIn(
              delay: const Duration(milliseconds: 70),
              child: _UpcomingCharges(charges: charges.value ?? const []),
            ),
            const SizedBox(height: AppSpacing.lg),
            FadeSlideIn(
              delay: const Duration(milliseconds: 140),
              child: _RecentTransactions(txns: txns.value ?? const []),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemainingCard extends StatelessWidget {
  const _RemainingCard({required this.snapshot, required this.periodLabel});

  final BudgetSnapshot snapshot;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final container = snapshot.health.container(scheme);
    final onContainer = snapshot.health.onContainer(scheme);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: ShapeDecoration(shape: AppShapes.hero, color: container),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                periodLabel,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: onContainer.withValues(alpha: 0.8),
                ),
              ),
              _HealthPill(health: snapshot.health),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // One clean spoken sentence for screen readers, instead of the
          // animating digits being read out mid-count.
          Semantics(
            container: true,
            label: '${L.of(context).remainingToSpend} : '
                '${snapshot.remaining.format()}, '
                '${_healthWord(context, snapshot.health)}',
            child: ExcludeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L.of(context).remainingToSpend,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: onContainer),
                  ),
                  // scaleDown keeps the hero figure on one line even at large
                  // system font sizes, instead of overflowing.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: TweenAnimationBuilder<double>(
                      duration: AppMotion.emphasized,
                      curve: AppMotion.standardCurve,
                      tween: Tween(end: snapshot.remaining.euros),
                      builder: (context, value, _) => Text(
                        Money.fromEuros(value).format(),
                        maxLines: 1,
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: onContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: snapshot.committedRatio,
              minHeight: 10,
              backgroundColor: onContainer.withValues(alpha: 0.15),
              color: onContainer,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                L.of(context).daysLeft(snapshot.daysRemaining),
                style: theme.textTheme.bodySmall?.copyWith(color: onContainer),
              ),
              Text(
                L.of(context).perDay(snapshot.perDay.format()),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _healthWord(BuildContext context, BudgetHealth health) {
  final l = L.of(context);
  return switch (health) {
    BudgetHealth.healthy => l.healthComfortable,
    BudgetHealth.caution => l.healthTight,
    BudgetHealth.danger => l.healthOver,
  };
}

class _HealthPill extends StatelessWidget {
  const _HealthPill({required this.health});

  final BudgetHealth health;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l = L.of(context);
    final (label, icon) = switch (health) {
      BudgetHealth.healthy => (l.healthComfortable, Icons.check_circle),
      BudgetHealth.caution => (l.healthTight, Icons.warning_amber_rounded),
      BudgetHealth.danger => (l.healthOver, Icons.error),
    };
    final color = health.color(scheme);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: ShapeDecoration(
        shape: AppShapes.pill,
        color: color.withValues(alpha: 0.18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpcomingCharges extends StatelessWidget {
  const _UpcomingCharges({required this.charges});

  final List<RecurrenceInstance> charges;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Only unpaid, soonest first, top 3.
    final pending = charges
        .where((c) => c.status != InstanceStatus.paid)
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final top = pending.take(3).toList();

    return _Section(
      title: L.of(context).upcomingCharges,
      trailing: pending.isEmpty ? null : '${pending.length}',
      child: top.isEmpty
          ? _EmptyLine(text: L.of(context).noChargesToPay)
          : Card(
              child: Column(
                children: [
                  for (final c in top) ...[
                    if (c != top.first)
                      const Divider(height: 1, indent: AppSpacing.md),
                    ListTile(
                      leading: const Icon(Icons.event_outlined),
                      title: Text(c.label),
                      subtitle: Text('échéance le ${c.dueDate.shortLabel}'),
                      trailing: Text(
                        Money(c.actualAmountCents ?? c.estimatedAmountCents)
                            .format(),
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions({required this.txns});

  final List<TxnView> txns;

  @override
  Widget build(BuildContext context) {
    final recent = txns.take(5).toList();
    return _Section(
      title: L.of(context).recentTransactions,
      child: recent.isEmpty
          ? const _FirstExpenseHint()
          : Card(
              child: Column(
                children: [
                  for (final v in recent) ...[
                    if (v != recent.first)
                      const Divider(height: 1, indent: 64),
                    _MiniTxnTile(view: v),
                  ],
                ],
              ),
            ),
    );
  }
}

/// Warm nudge shown to a fresh user who hasn't logged anything yet.
class _FirstExpenseHint extends StatelessWidget {
  const _FirstExpenseHint();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      color: scheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: scheme.primaryContainer,
              foregroundColor: scheme.onPrimaryContainer,
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    L.of(context).firstExpenseTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    L.of(context).firstExpenseBody,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniTxnTile extends StatelessWidget {
  const _MiniTxnTile({required this.view});

  final TxnView view;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final txn = view.txn;
    final category = view.category;
    final isIncome = txn.type == TxnType.income;
    final color =
        category != null ? Color(category.colorValue) : scheme.primary;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.16),
        foregroundColor: color,
        child: Icon(iconFor(category?.iconKey), size: 20),
      ),
      title: Text(category?.name ?? 'Non catégorisé'),
      subtitle: Text(txn.date.shortLabel),
      trailing: AmountText(
        isIncome ? Money(txn.amountCents) : -Money(txn.amountCents),
        signed: true,
        colorBySign: isIncome,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              Text(title, style: theme.textTheme.titleMedium),
              if (trailing != null)
                Text(
                  trailing!,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _RemainingSkeleton extends StatelessWidget {
  const _RemainingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: ShapeDecoration(
          shape: AppShapes.hero,
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonBox(width: 120, height: 14),
            SizedBox(height: AppSpacing.md),
            SkeletonBox(width: 200, height: 40),
            SizedBox(height: AppSpacing.md),
            SkeletonBox(height: 10, radius: AppRadius.full),
            SizedBox(height: AppSpacing.sm),
            SkeletonBox(width: 140, height: 12),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: ShapeDecoration(
        shape: AppShapes.hero,
        color: scheme.errorContainer,
      ),
      child: Text(
        'Impossible de calculer le budget :\n$message',
        style: TextStyle(color: scheme.onErrorContainer),
      ),
    );
  }
}
