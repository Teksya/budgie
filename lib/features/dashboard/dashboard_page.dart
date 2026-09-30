import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/motion.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/stats_repository.dart';
import 'package:budget/data/repositories/transaction_repository.dart';
import 'package:budget/domain/services/budget_engine.dart';
import 'package:budget/features/favorites/favorites_bar.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/widgets/amount_text.dart';
import 'package:budget/shared/widgets/backup_reminder_card.dart';
import 'package:budget/shared/widgets/budget_ring.dart';
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
    final breakdown = ref.watch(categoryBreakdownProvider);

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
                data: (s) => _RemainingCard(
                  snapshot: s,
                  periodLabel: range.label,
                  slices: breakdown.value ?? const [],
                ),
              ),
            ),
            const FadeSlideIn(
              delay: Duration(milliseconds: 30),
              child: _SpendingTrend(),
            ),
            const SizedBox(height: AppSpacing.lg),
            const FadeSlideIn(
              delay: Duration(milliseconds: 40),
              child: BackupReminderCard(),
            ),
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
  const _RemainingCard({
    required this.snapshot,
    required this.periodLabel,
    required this.slices,
  });

  final BudgetSnapshot snapshot;
  final String periodLabel;
  final List<CategorySlice> slices;

  /// Splits the period's money into arcs: one per category actually spent on,
  /// one for what is committed but not yet spent (unpaid charges, planned
  /// savings), and one for what is still free to spend.
  List<RingSegment> _segments(L l, ColorScheme scheme, Color onContainer) {
    final spent = slices.fold(Money.zero, (a, s) => a + s.total);
    // Beyond four arcs the ring turns into confetti — fold the tail into one.
    final top = slices.take(4);
    final others = slices.skip(4).fold(Money.zero, (a, s) => a + s.total);

    return [
      for (final s in top)
        RingSegment(
          label: s.categoryName,
          color: Color(s.colorValue),
          amount: s.total.euros,
        ),
      RingSegment(
        label: l.ringOthers,
        color: onContainer.withValues(alpha: 0.25),
        amount: others.euros,
      ),
      RingSegment(
        label: l.statusPending,
        color: onContainer.withValues(alpha: 0.5),
        amount: (snapshot.totalCommitted - spent).euros,
      ),
      RingSegment(
        label: l.ringFree,
        color: snapshot.health.color(scheme),
        amount: snapshot.remaining.euros,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final container = snapshot.health.container(scheme);
    final onContainer = snapshot.health.onContainer(scheme);
    final segments = _segments(L.of(context), scheme, onContainer);

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
          Center(
            child: BudgetRing(
              segments: segments,
              emptyColor: onContainer.withValues(alpha: 0.15),
              // The arcs are pixels; this sentence is the whole chart for a
              // screen reader, so it carries the figure *and* the breakdown.
              semanticsLabel:
                  '${L.of(context).remainingToSpend} : '
                  '${snapshot.remaining.format()}, '
                  '${_healthWord(context, snapshot.health)}. '
                  '${L.of(context).daysLeft(snapshot.daysRemaining)}, '
                  '${L.of(context).perDay(snapshot.perDay.format())}. '
                  '${_ringSummary(segments)}',
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    L.of(context).remainingToSpend,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: onContainer.withValues(alpha: 0.8),
                    ),
                  ),
                  // scaleDown keeps the hero figure on one line even at large
                  // system font sizes, instead of overflowing the ring's hole.
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: TweenAnimationBuilder<double>(
                      duration: AppMotion.emphasized,
                      curve: AppMotion.standardCurve,
                      tween: Tween(end: snapshot.remaining.euros),
                      builder: (context, value, _) => Text(
                        Money.fromEuros(value).formatRounded(),
                        maxLines: 1,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: onContainer,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    L.of(context).perDay(snapshot.perDay.format()),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: onContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Align(child: RingLegend(segments: segments)),
          const SizedBox(height: AppSpacing.sm),
          Align(
            child: Text(
              L.of(context).daysLeft(snapshot.daysRemaining),
              style: theme.textTheme.bodySmall?.copyWith(
                color: onContainer.withValues(alpha: 0.8),
              ),
            ),
          ),
          if (snapshot.projectedRemaining != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _Projection(snapshot: snapshot, onContainer: onContainer),
          ],
        ],
      ),
    );
  }
}

/// "At this rate you finish the month at X" — the one number the headline
/// cannot show, because the headline is a balance and this is a trajectory.
class _Projection extends StatelessWidget {
  const _Projection({required this.snapshot, required this.onContainer});

  final BudgetSnapshot snapshot;
  final Color onContainer;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final projected = snapshot.projectedRemaining!;
    // Only tint it when it disagrees with the headline; otherwise it is just
    // one more figure and should read as quietly as the rest of the card.
    final colour = snapshot.projectionWarns
        ? theme.colorScheme.error
        : onContainer.withValues(alpha: 0.8);

    return Align(
      child: MergeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              snapshot.projectionWarns
                  ? Icons.trending_down
                  : Icons.trending_flat,
              size: 16,
              color: colour,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${l.projectedEndTitle}, '
                '${l.projectedEndBody(projected.formatRounded())}',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colour,
                  fontWeight: snapshot.projectionWarns ? FontWeight.w700 : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "12 % less than last month", measured over the same number of elapsed days
/// so the comparison is fair mid-month.
class _SpendingTrend extends ConsumerWidget {
  const _SpendingTrend();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comparison = ref.watch(spendingComparisonProvider).value;
    final ratio = comparison?.ratio;
    if (ratio == null) return const SizedBox.shrink();

    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final percent = (ratio.abs() * 100).round();

    // Under 5 % is noise, not a trend.
    final (label, icon, colour) = percent < 5
        ? (l.vsLastMonthSame, Icons.trending_flat, scheme.onSurfaceVariant)
        : ratio < 0
        ? (l.vsLastMonthLess(percent), Icons.trending_down, scheme.healthy)
        : (l.vsLastMonthMore(percent), Icons.trending_up, scheme.caution);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: MergeSemantics(
        child: Row(
          children: [
            Icon(icon, size: 16, color: colour),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(color: colour),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Spells the arcs out for a screen reader — "Courses 120 €, Libre 430 €".
String _ringSummary(List<RingSegment> segments) => segments
    .where((s) => s.amount > 0)
    .map((s) => '${s.label} ${Money.fromEuros(s.amount).formatRounded()}')
    .join(', ');

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
    final pending =
        charges.where((c) => c.status != InstanceStatus.paid).toList()
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
                      subtitle: Text(
                        L.of(context).widgetBillDue(c.dueDate.shortLabel),
                      ),
                      trailing: Text(
                        Money(
                          c.actualAmountCents ?? c.estimatedAmountCents,
                        ).format(),
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
                    if (v != recent.first) const Divider(height: 1, indent: 64),
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
      // Clips the ripple to the card's own shape, so the tap target does not
      // have to know the corner radius.
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        // The card reads like a call to action, so it should behave like one
        // rather than only pointing at the button below it.
        onTap: () => context.push('/add'),
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
              Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
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
    final color = category != null
        ? Color(category.colorValue)
        : scheme.primary;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.16),
        foregroundColor: color,
        child: Icon(iconFor(category?.iconKey), size: 20),
      ),
      title: Text(category?.name ?? L.of(context).uncategorized),
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
