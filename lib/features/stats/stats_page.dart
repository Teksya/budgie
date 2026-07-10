import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/repositories/stats_repository.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(currentPeriodRangeProvider);
    final breakdownAsync = ref.watch(categoryBreakdownProvider);
    final seriesAsync = ref.watch(monthlySeriesProvider);
    final loading = breakdownAsync.isLoading && !breakdownAsync.hasValue;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: loading
          ? const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: SkeletonList(rows: 5),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xl * 2,
              ),
              children: [
                _SectionTitle('Dépenses par catégorie · ${range.label}'),
                _CategoryDonut(slices: breakdownAsync.value ?? const []),
                const SizedBox(height: AppSpacing.lg),
                const _SectionTitle('Revenus et dépenses'),
                _MonthlyBars(series: seriesAsync.value ?? const []),
              ],
            ),
    );
  }
}

class _CategoryDonut extends StatelessWidget {
  const _CategoryDonut({required this.slices});

  final List<CategorySlice> slices;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (slices.isEmpty) {
      return const _EmptyCard(text: 'Aucune dépense ce mois-ci.');
    }
    final total = slices.fold(Money.zero, (a, s) => a + s.total);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 58,
                      sections: [
                        for (final s in slices)
                          PieChartSectionData(
                            value: s.total.euros,
                            color: Color(s.colorValue),
                            radius: 26,
                            showTitle: false,
                          ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total', style: theme.textTheme.labelMedium),
                      Text(
                        total.formatRounded(),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            for (final s in slices)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Color(s.colorValue),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(s.categoryName)),
                    Text(
                      '${(s.total.ratioOf(total) * 100).round()} %',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Text(
                      s.total.format(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
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

class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({required this.series});

  final List<MonthPoint> series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    if (series.isEmpty) {
      return const _EmptyCard(text: 'Pas encore de données.');
    }
    // Keep the last 12 months at most.
    final points = series.length > 12
        ? series.sublist(series.length - 12)
        : series;
    final maxEuros = points
        .map((p) => p.income.euros > p.expense.euros ? p.income.euros : p.expense.euros)
        .fold<double>(0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendDot(color: scheme.healthy, label: 'Revenus'),
                const SizedBox(width: AppSpacing.md),
                _LegendDot(color: scheme.primary, label: 'Dépenses'),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxEuros == 0 ? 100 : maxEuros * 1.2,
                  barTouchData: const BarTouchData(enabled: false),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
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
                              _monthLetter(points[i].start),
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
                            width: 7,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          BarChartRodData(
                            toY: points[i].expense.euros,
                            color: scheme.primary,
                            width: 7,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ],
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

  static String _monthLetter(DateTime d) =>
      d.shortLabel.split(' ').last;
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
