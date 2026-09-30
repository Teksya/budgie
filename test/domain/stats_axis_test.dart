import 'package:budget/features/stats/stats_page.dart';
import 'package:flutter_test/flutter_test.dart';

/// An axis whose top reads "1,03 k" is an axis nobody reads.
void main() {
  test('rounds up to a figure a person would put on an axis', () {
    expect(niceAxisCeiling(899), 1000);
    expect(niceAxisCeiling(60), 100);
    expect(niceAxisCeiling(1200), 2000);
    expect(niceAxisCeiling(4300), 5000);
    expect(niceAxisCeiling(350), 400);
  });

  test('an exact round value is not pushed to the next step', () {
    expect(niceAxisCeiling(1000), 1000);
    expect(niceAxisCeiling(500), 500);
  });

  test('an empty month still gets a scale to draw against', () {
    expect(niceAxisCeiling(0), 100);
    expect(niceAxisCeiling(-5), 100);
  });

  test('the halfway gridline lands on a round number too', () {
    for (final v in [37.0, 240.0, 899.0, 1234.0, 8000.0]) {
      final half = niceAxisCeiling(v) / 2;
      expect(half, half.roundToDouble(), reason: 'half of ${niceAxisCeiling(v)}');
    }
  });
}
