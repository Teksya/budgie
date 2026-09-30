import 'package:budget/shared/widgets/budget_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The ring is fed straight from live budget maths, which routinely produces
/// zero and negative arcs (nothing spent yet, overspent month). `fl_chart`
/// renders those as artefacts, so [BudgetRing] must drop them — and it must
/// still draw something when *every* arc is empty.
void main() {
  Future<void> pump(WidgetTester tester, List<RingSegment> segments) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: BudgetRing(
                segments: segments,
                semanticsLabel: 'ring',
                center: const Text('centre'),
              ),
            ),
          ),
        ),
      );

  const red = Color(0xFFFF0000);

  testWidgets('a fresh month with nothing spent still renders', (tester) async {
    await pump(tester, const []);
    expect(tester.takeException(), isNull);
    expect(find.text('centre'), findsOneWidget);
  });

  testWidgets('zero and negative arcs do not reach the chart', (tester) async {
    await pump(tester, const [
      RingSegment(label: 'vide', color: red, amount: 0),
      RingSegment(label: 'dépassement', color: red, amount: -120),
      RingSegment(label: 'courses', color: red, amount: 300),
    ]);
    expect(tester.takeException(), isNull);
    expect(find.text('centre'), findsOneWidget);
  });

  testWidgets('the legend lists only the arcs actually drawn', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RingLegend(
            segments: [
              RingSegment(label: 'courses', color: red, amount: 300),
              RingSegment(label: 'libre', color: red, amount: 0),
            ],
          ),
        ),
      ),
    );
    expect(find.text('courses'), findsOneWidget);
    expect(find.text('libre'), findsNothing);
  });
}
