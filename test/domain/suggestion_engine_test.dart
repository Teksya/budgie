import 'package:budget/core/money.dart';
import 'package:budget/domain/services/suggestion_engine.dart';
import 'package:flutter_test/flutter_test.dart';

SpendingSample sample({
  required int periodId,
  required int day,
  required double euros,
  int? categoryId,
  String? note,
}) => SpendingSample(
  periodId: periodId,
  date: DateTime(2026, periodId, day),
  amount: Money.fromEuros(euros),
  categoryId: categoryId,
  note: note,
);

void main() {
  group('recurrence suggestions', () {
    test('spots the same charge in three different months', () {
      final found = SuggestionEngine.recurrences([
        sample(periodId: 5, day: 4, euros: 13.49, note: 'Netflix'),
        sample(periodId: 6, day: 5, euros: 13.49, note: 'netflix'),
        sample(periodId: 7, day: 5, euros: 13.49, note: 'Netflix'),
      ]);

      expect(found, hasLength(1));
      expect(found.single.label, 'Netflix');
      expect(found.single.amount, Money.fromEuros(13.49));
      expect(found.single.dayOfMonth, 5);
      expect(found.single.occurrences, 3);
    });

    test('two months is a coincidence, not a habit', () {
      final found = SuggestionEngine.recurrences([
        sample(periodId: 6, day: 5, euros: 13.49, note: 'Netflix'),
        sample(periodId: 7, day: 5, euros: 13.49, note: 'Netflix'),
      ]);
      expect(found, isEmpty);
    });

    test('three times in the same month is not a recurrence either', () {
      final found = SuggestionEngine.recurrences([
        sample(periodId: 7, day: 2, euros: 13.49, note: 'Netflix'),
        sample(periodId: 7, day: 12, euros: 13.49, note: 'Netflix'),
        sample(periodId: 7, day: 22, euros: 13.49, note: 'Netflix'),
      ]);
      expect(found, isEmpty, reason: 'one month cannot show a monthly pattern');
    });

    test('a wandering amount is shopping, not a subscription', () {
      final found = SuggestionEngine.recurrences([
        sample(periodId: 5, day: 4, euros: 42, note: 'Carrefour'),
        sample(periodId: 6, day: 5, euros: 88, note: 'Carrefour'),
        sample(periodId: 7, day: 5, euros: 61, note: 'Carrefour'),
      ]);
      expect(found, isEmpty);
    });

    test('never suggests what the user already tracks', () {
      final found = SuggestionEngine.recurrences(
        [
          sample(periodId: 5, day: 4, euros: 13.49, note: 'Netflix'),
          sample(periodId: 6, day: 5, euros: 13.49, note: 'Netflix'),
          sample(periodId: 7, day: 5, euros: 13.49, note: 'Netflix'),
        ],
        alreadyTracked: {'netflix'},
      );
      expect(found, isEmpty);
    });

    test('ignores expenses with no note to group on', () {
      final found = SuggestionEngine.recurrences([
        sample(periodId: 5, day: 4, euros: 13.49),
        sample(periodId: 6, day: 5, euros: 13.49),
        sample(periodId: 7, day: 5, euros: 13.49),
      ]);
      expect(found, isEmpty);
    });
  });

  group('envelope suggestions', () {
    test('averages a category over the months it appears in', () {
      final found = SuggestionEngine.envelopes([
        sample(periodId: 5, day: 3, euros: 300, categoryId: 7),
        sample(periodId: 6, day: 3, euros: 340, categoryId: 7),
        sample(periodId: 7, day: 3, euros: 320, categoryId: 7),
      ]);

      expect(found, hasLength(1));
      expect(found.single.categoryId, 7);
      expect(found.single.average, Money.fromEuros(320));
      expect(found.single.months, 3);
    });

    test('sums several expenses within the same month', () {
      final found = SuggestionEngine.envelopes([
        sample(periodId: 5, day: 3, euros: 100, categoryId: 7),
        sample(periodId: 5, day: 9, euros: 100, categoryId: 7),
        sample(periodId: 6, day: 3, euros: 200, categoryId: 7),
        sample(periodId: 7, day: 3, euros: 200, categoryId: 7),
      ]);
      expect(found.single.average, Money.fromEuros(200));
    });

    test('the suggested cap leaves headroom and reads like a human figure', () {
      final found = SuggestionEngine.envelopes([
        sample(periodId: 5, day: 3, euros: 320, categoryId: 7),
        sample(periodId: 6, day: 3, euros: 320, categoryId: 7),
        sample(periodId: 7, day: 3, euros: 320, categoryId: 7),
      ]);
      // 320 + 10 % = 352 → the next 50 € step.
      expect(found.single.suggestedLimit, Money.fromEuros(400));

      final small = SuggestionEngine.envelopes([
        sample(periodId: 5, day: 3, euros: 42, categoryId: 9),
        sample(periodId: 6, day: 3, euros: 42, categoryId: 9),
        sample(periodId: 7, day: 3, euros: 42, categoryId: 9),
      ]);
      // 42 + 10 % = 46,20 → the next 10 € step.
      expect(small.single.suggestedLimit, Money.fromEuros(50));
    });

    test('stays quiet with less than three months of history', () {
      final found = SuggestionEngine.envelopes([
        sample(periodId: 6, day: 3, euros: 300, categoryId: 7),
        sample(periodId: 7, day: 3, euros: 300, categoryId: 7),
      ]);
      expect(found, isEmpty);
    });

    test('skips a category that already has an envelope', () {
      final found = SuggestionEngine.envelopes(
        [
          sample(periodId: 5, day: 3, euros: 300, categoryId: 7),
          sample(periodId: 6, day: 3, euros: 300, categoryId: 7),
          sample(periodId: 7, day: 3, euros: 300, categoryId: 7),
        ],
        alreadyCapped: {7},
      );
      expect(found, isEmpty);
    });

    test('biggest spend first — that is where a cap is worth setting', () {
      final found = SuggestionEngine.envelopes([
        for (final p in [5, 6, 7]) ...[
          sample(periodId: p, day: 3, euros: 50, categoryId: 1),
          sample(periodId: p, day: 3, euros: 300, categoryId: 2),
        ],
      ]);
      expect(found.map((e) => e.categoryId), [2, 1]);
    });
  });
}
