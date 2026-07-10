import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Trend of a variable charge's real amounts (électricité, eau…), with a
/// one-tap way to realign its estimate on the observed average.
class ChargeHistoryPage extends ConsumerWidget {
  const ChargeHistoryPage({required this.recurrence, super.key});

  final Recurrence recurrence;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final history = ref.watch(chargeHistoryProvider(recurrence.id)).value ??
        const [];

    final amounts = history
        .map((i) => Money(i.actualAmountCents ?? i.estimatedAmountCents))
        .toList();
    final average = amounts.isEmpty
        ? Money.zero
        : Money(amounts.sum.cents ~/ amounts.length);
    final estimate = Money(recurrence.estimatedAmountCents);
    final drift = average - estimate;
    final showAdjust = amounts.length >= 3 &&
        estimate.cents > 0 &&
        (drift.abs.cents / estimate.cents) > 0.15;

    return Scaffold(
      appBar: AppBar(title: Text(recurrence.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl * 2,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: _Stat(label: 'Estimé actuel', value: estimate.format()),
              ),
              Expanded(
                child: _Stat(
                  label: 'Moyenne réelle',
                  value: amounts.isEmpty ? '—' : average.format(),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (history.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'Pas encore de facture payée pour cette charge. '
                  "L'historique apparaîtra ici au fil des mois.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SizedBox(
                  height: 220,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: (amounts
                                  .map((m) => m.euros)
                                  .fold<double>(0, (a, b) => a > b ? a : b)) *
                              1.2 +
                          1,
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
                              if (i < 0 || i >= history.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  DateFormat('MMM', 'fr_FR')
                                      .format(history[i].dueDate),
                                  style: theme.textTheme.labelSmall,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      barGroups: [
                        for (var i = 0; i < amounts.length; i++)
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: amounts[i].euros,
                                color: scheme.primary,
                                width: 14,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          if (showAdjust) ...[
            const SizedBox(height: AppSpacing.md),
            Card(
              color: scheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ton estimé s'écarte de la réalité",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'La moyenne réelle est ${average.format()}, '
                      '${drift.isNegative ? 'sous' : 'au-dessus de'} '
                      "l'estimé de ${drift.abs.format()}.",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    FilledButton(
                      onPressed: () async {
                        await ref
                            .read(recurrenceRepositoryProvider)
                            .setEstimate(recurrence.id, average.cents);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: Text("Réajuster l'estimé à ${average.format()}"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
