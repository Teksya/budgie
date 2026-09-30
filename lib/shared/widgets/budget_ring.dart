import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// One coloured arc of a [BudgetRing].
@immutable
class RingSegment {
  const RingSegment({
    required this.label,
    required this.color,
    required this.amount,
  });

  final String label;
  final Color color;

  /// Relative weight of the arc, in euros. Non-positive arcs are dropped —
  /// `fl_chart` renders a zero-value section as a visual glitch.
  final double amount;
}

/// A donut with an open middle: the arcs carry the breakdown, [center] carries
/// the figure that actually matters. Hero of the dashboard, reused by Stats.
///
/// Paints no semantics of its own (arcs are pixels), so [semanticsLabel] is
/// the only thing a screen reader gets — spell the chart out there.
class BudgetRing extends StatelessWidget {
  const BudgetRing({
    required this.segments,
    required this.center,
    required this.semanticsLabel,
    this.size = 216,
    this.thickness = 22,
    this.emptyColor,
    super.key,
  });

  final List<RingSegment> segments;
  final Widget center;
  final String semanticsLabel;
  final double size;
  final double thickness;

  /// Colour of the "nothing yet" ring. Defaults to a neutral surface, which is
  /// wrong on a tinted card — pass a tint of the card's own ink there.
  final Color? emptyColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final drawn = segments.where((s) => s.amount > 0).toList();

    return Semantics(
      label: semanticsLabel,
      excludeSemantics: true,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (drawn.isEmpty)
              // An empty month still has to read as a ring, not a blank hole.
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: emptyColor ?? scheme.surfaceContainerHighest,
                    width: thickness,
                  ),
                ),
              )
            else
              PieChart(
                PieChartData(
                  // A single arc closing on itself must not show a seam.
                  sectionsSpace: drawn.length > 1 ? 3 : 0,
                  centerSpaceRadius: size / 2 - thickness,
                  // Otherwise fl_chart fills the hole with a pale disc, which
                  // on a tinted card reads as a second, fatter ring.
                  centerSpaceColor: Colors.transparent,
                  startDegreeOffset: -90,
                  sections: [
                    for (final s in drawn)
                      PieChartSectionData(
                        value: s.amount,
                        color: s.color,
                        radius: thickness,
                        showTitle: false,
                      ),
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.all(thickness + 10),
              child: center,
            ),
          ],
        ),
      ),
    );
  }
}

/// The colour key for a [BudgetRing]. Kept next to the ring because a donut
/// without a legend is decoration, not information.
class RingLegend extends StatelessWidget {
  const RingLegend({required this.segments, super.key});

  final List<RingSegment> segments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 6,
      children: [
        for (final s in segments.where((s) => s.amount > 0))
          MergeSemantics(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: s.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(s.label, style: theme.textTheme.labelMedium),
              ],
            ),
          ),
      ],
    );
  }
}
