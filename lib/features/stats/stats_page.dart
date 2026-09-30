import 'dart:math' as math;

import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/repositories/stats_repository.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/widgets/budget_ring.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Where the money went, over a stretch the user picks.
///
/// The screen used to show one fixed month and a bar chart, which answered
/// "what did I spend on" but never "is that a lot" — the question anyone
/// opening a stats page is actually asking. Everything here is therefore
/// framed against something: the previous stretch, the monthly average, or the
/// total.
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  static const _ranges = [1, 3, 6, 12];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final months = ref.watch(statsRangeMonthsProvider);
    final statsAsync = ref.watch(rangeStatsProvider);
    final stats = statsAsync.value;

    return Scaffold(
      appBar: AppBar(title: Text(l.statsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xl * 2,
        ),
        children: [
          // Chips rather than a segmented button: four French labels do not fit
          // across a phone, and these wrap instead of squeezing.
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final n in _ranges)
                ChoiceChip(
                  label: Text(l.statsRangeMonths(n)),
                  selected: months == n,
                  onSelected: (_) =>
                      ref.read(statsRangeMonthsProvider.notifier).select(n),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          if (stats == null)
            const SkeletonList(rows: 5)
          else if (stats.isEmpty)
            _EmptyCard(text: l.noDataYet)
          else ...[
            _Summary(stats: stats),
            const SizedBox(height: AppSpacing.lg),
            if (stats.months.length >= 2) ...[
              _SectionTitle(l.statsTrend),
              _MonthlyBars(points: stats.months),
              const SizedBox(height: AppSpacing.lg),
            ],
            _SectionTitle(l.statsByCategory),
            _CategoryBreakdown(stats: stats),
            if (stats.merchants.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.lg),
              _SectionTitle(l.statsRepeatOffenders),
              _Merchants(merchants: stats.merchants, total: stats.expenses),
            ],
          ],
        ],
      ),
    );
  }
}

/// The three figures that frame everything below them.
class _Summary extends StatelessWidget {
  const _Summary({required this.stats});

  final RangeStats stats;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final saved = !stats.net.isNegative;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _Figure(
                    label: l.income,
                    amount: stats.income,
                    color: scheme.healthy,
                  ),
                ),
                Expanded(
                  child: _Figure(
                    label: l.expenses,
                    amount: stats.expenses,
                    color: scheme.primary,
                  ),
                ),
                Expanded(
                  child: _Figure(
                    label: saved ? l.saved : l.deficit,
                    amount: stats.net.abs,
                    color: saved ? scheme.healthy : scheme.error,
                  ),
                ),
              ],
            ),
            // With a single month the average is the same number twice over.
            if (stats.monthCount > 1) ...[
              const Divider(height: AppSpacing.lg),
              Text(
                l.statsAveragePerMonth(stats.averageSpend.formatRounded()),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final Money amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MergeSemantics(
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount.formatRounded(),
              maxLines: 1,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The ring, then one ranked row per category with a proportional bar and how
/// it moved. The bar is what turns a list of numbers into a shape you can read
/// at a glance; the delta is what makes it actionable.
class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({required this.stats});

  final RangeStats stats;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    if (stats.categories.isEmpty) {
      return _EmptyCard(text: l.noSpendingThisMonth);
    }

    final total = stats.expenses;
    final biggest = stats.categories.first.total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            BudgetRing(
              size: 180,
              thickness: 24,
              // Every slice is spelled out in the rows below, so the chart
              // itself only needs to announce the total.
              semanticsLabel: l.donutSemantics(total.formatRounded()),
              segments: [
                for (final c in stats.categories.take(6))
                  RingSegment(
                    label: c.name,
                    color: Color(c.colorValue),
                    amount: c.total.euros,
                  ),
              ],
              center: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l.total, style: theme.textTheme.labelMedium),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      total.formatRounded(),
                      maxLines: 1,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final c in stats.categories)
              _CategoryRow(stat: c, total: total, biggest: biggest),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.stat,
    required this.total,
    required this.biggest,
  });

  final CategoryStat stat;
  final Money total;

  /// The top category's spend, so bars are scaled against the leader and the
  /// smaller ones stay visible instead of collapsing to a sliver.
  final Money biggest;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final colour = Color(stat.colorValue);
    final delta = stat.delta;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: MergeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(child: Text(stat.name)),
                if (delta != null && delta.abs() >= 0.05) ...[
                  Icon(
                    delta < 0 ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 13,
                    // Spending less is the good direction here, whatever the
                    // category — this is an expenses-only list.
                    color: delta < 0 ? scheme.healthy : scheme.caution,
                  ),
                  Text(
                    l.statsDeltaPercent((delta.abs() * 100).round()),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: delta < 0 ? scheme.healthy : scheme.caution,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  stat.total.format(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: LinearProgressIndicator(
                value: biggest.isPositive
                    ? stat.total.cents / biggest.cents
                    : 0,
                minHeight: 6,
                backgroundColor: scheme.surfaceContainerHighest,
                color: colour,
                semanticsLabel: stat.name,
                semanticsValue: l.statsShareOfTotal(
                  (stat.total.ratioOf(total) * 100).round(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Notes that come back. A category says "groceries"; this says which shop,
/// which is the level at which spending is actually decided.
class _Merchants extends StatelessWidget {
  const _Merchants({required this.merchants, required this.total});

  final List<MerchantStat> merchants;
  final Money total;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            for (final m in merchants)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: MergeSemantics(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          m.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        l.statsTimes(m.count),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Text(
                        m.total.format(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({required this.points});

  final List<MonthPoint> points;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final maxEuros = points
        .map((p) => p.income.euros > p.expense.euros
            ? p.income.euros
            : p.expense.euros)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final top = niceAxisCeiling(maxEuros);
    // Bare numbers, abbreviated: an axis has no room for "1 234,00 €".
    final compact = NumberFormat.compact();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: scheme.healthy, label: l.income),
                const SizedBox(width: AppSpacing.md),
                _LegendDot(color: scheme.primary, label: l.expenses),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Unlike the ring this chart has no textual twin on screen, so the
            // spoken summary is the only way in for a screen-reader user.
            Semantics(
              label: _barsSummary(l, points),
              excludeSemantics: true,
              child: SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: top,
                    barTouchData: const BarTouchData(enabled: false),
                    // Without a scale the bars were decoration: a tall green
                    // one next to a blue sliver told you nothing about how much
                    // either was. Three faint lines and their labels turn it
                    // back into a chart.
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: top / 2,
                      getDrawingHorizontalLine: (_) => FlLine(
                        color: scheme.outlineVariant,
                        strokeWidth: 1,
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 38,
                          interval: top / 2,
                          getTitlesWidget: (value, meta) => Text(
                            compact.format(value),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final i = value.toInt();
                            if (i < 0 || i >= points.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                _label(points, i),
                                style: theme.textTheme.labelSmall,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (var i = 0; i < points.length; i++)
                        BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: points[i].income.euros,
                              color: scheme.healthy,
                              // Thinner bars once a year is on screen, or the
                              // twelve pairs collide.
                              width: points.length > 6 ? 5 : 8,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            BarChartRodData(
                              toY: points[i].expense.euros,
                              color: scheme.primary,
                              width: points.length > 6 ? 5 : 8,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The month, plus the start day when two periods land in the same month —
  /// which happens as soon as the user moves the budget start day.
  static String _label(List<MonthPoint> points, int i) {
    final start = points[i].start;
    final month = start.shortLabel.split(' ').last;
    final collides = points.where((p) => p.start.month == start.month).length > 1;
    return collides ? '${start.day} $month' : month;
  }

  /// Spells the chart out month by month: the bars themselves are pixels only.
  static String _barsSummary(L l, List<MonthPoint> points) {
    final months = points
        .map(
          (p) => l.barsMonthSummary(
            DateFormat('MMMM').format(p.start),
            p.income.formatRounded(),
            p.expense.formatRounded(),
          ),
        )
        .join('. ');
    return l.barsSummary(points.length, months);
  }
}

/// A round number just above [value], so a chart axis reads 0 / 500 / 1 000
/// rather than 0 / 517 / 1,03 k. Gridlines are only useful if you can read them
/// at a glance.
///
/// Public so it can be tested without copying the rule into the test, which is
/// how a rule and its test quietly drift apart.
double niceAxisCeiling(double value) {
  if (value <= 0) return 100;
  // The chart draws the top and the halfway line, so every step here has to
  // stay even — hence 4 rather than 3, and no 2.5.
  const steps = [1.0, 2.0, 4.0, 5.0, 10.0];
  final magnitude = math.pow(10, (math.log(value) / math.ln10).floor())
      .toDouble();
  for (final step in steps) {
    final candidate = step * magnitude;
    if (candidate >= value) return candidate;
  }
  return 10 * magnitude;
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(label, style: Theme.of(context).textTheme.labelMedium),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      left: AppSpacing.xs,
      bottom: AppSpacing.sm,
    ),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
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
