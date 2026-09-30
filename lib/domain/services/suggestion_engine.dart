import 'package:budget/core/money.dart';
import 'package:meta/meta.dart';

/// One past expense, reduced to what the suggestion rules actually look at.
@immutable
class SpendingSample {
  const SpendingSample({
    required this.periodId,
    required this.date,
    required this.amount,
    this.categoryId,
    this.note,
  });

  final int periodId;
  final DateTime date;
  final Money amount;
  final int? categoryId;
  final String? note;
}

/// "You have paid Netflix three months running — make it a subscription?"
@immutable
class RecurrenceSuggestion {
  const RecurrenceSuggestion({
    required this.label,
    required this.amount,
    required this.dayOfMonth,
    required this.occurrences,
    this.categoryId,
  });

  /// The note the expenses share, which is also the name to propose.
  final String label;

  /// Typical amount: the median, so one odd month does not drag it.
  final Money amount;

  final int dayOfMonth;
  final int occurrences;
  final int? categoryId;
}

/// "You spend about 340 € a month on groceries — cap it at 350?"
@immutable
class EnvelopeSuggestion {
  const EnvelopeSuggestion({
    required this.categoryId,
    required this.average,
    required this.suggestedLimit,
    required this.months,
  });

  final int categoryId;
  final Money average;

  /// The average with a little headroom, rounded to something a human would
  /// have typed. A cap set exactly at the average is breached every other month.
  final Money suggestedLimit;

  final int months;
}

/// Turns spending history into the two nudges the app can make on its own.
///
/// Pure and month-agnostic: callers pass the samples and the rules decide.
/// Nothing here writes anything — a suggestion is only ever a proposal.
abstract final class SuggestionEngine {
  /// Below this many occurrences, a repeat is a coincidence.
  static const int minOccurrencesForRecurrence = 3;

  /// Below this many months of history, an average means nothing.
  static const int minMonthsForEnvelope = 3;

  /// Amounts this far apart are not "the same charge".
  static const double _amountTolerance = 0.15;

  /// Expenses sharing a note, landing around the same day, at around the same
  /// amount, in [minOccurrencesForRecurrence] distinct months or more.
  ///
  /// [alreadyTracked] holds the labels of existing recurrences, lower-cased, so
  /// the app never suggests what the user already set up.
  static List<RecurrenceSuggestion> recurrences(
    List<SpendingSample> samples, {
    Set<String> alreadyTracked = const {},
  }) {
    final byLabel = <String, List<SpendingSample>>{};
    for (final s in samples) {
      final label = s.note?.trim();
      if (label == null || label.length < 3) continue;
      final key = label.toLowerCase();
      if (alreadyTracked.contains(key)) continue;
      (byLabel[key] ??= []).add(s);
    }

    final result = <RecurrenceSuggestion>[];
    for (final entry in byLabel.entries) {
      final group = entry.value;
      // Distinct months, so three expenses in one week are not a recurrence.
      final months = group.map((s) => s.periodId).toSet();
      if (months.length < minOccurrencesForRecurrence) continue;

      final amounts = group.map((s) => s.amount.cents).toList()..sort();
      final median = amounts[amounts.length ~/ 2];
      if (median <= 0) continue;

      // A subscription costs about the same every month; a supermarket run
      // does not. This is what separates the two.
      final spread = (amounts.last - amounts.first) / median;
      if (spread > _amountTolerance) continue;

      final days = group.map((s) => s.date.day).toList()..sort();
      result.add(
        RecurrenceSuggestion(
          // The original casing of the first occurrence reads better than the
          // lower-cased key used for grouping.
          label: group.first.note!.trim(),
          amount: Money(median),
          dayOfMonth: days[days.length ~/ 2],
          occurrences: months.length,
          categoryId: group.first.categoryId,
        ),
      );
    }

    result.sort((a, b) => b.occurrences.compareTo(a.occurrences));
    return result;
  }

  /// Average monthly spend per category over the months present in [samples].
  ///
  /// [alreadyCapped] holds the categories that already have an envelope.
  static List<EnvelopeSuggestion> envelopes(
    List<SpendingSample> samples, {
    Set<int> alreadyCapped = const {},
  }) {
    final byCategory = <int, Map<int, int>>{};
    for (final s in samples) {
      final category = s.categoryId;
      if (category == null || alreadyCapped.contains(category)) continue;
      final perMonth = byCategory[category] ??= {};
      perMonth[s.periodId] = (perMonth[s.periodId] ?? 0) + s.amount.cents;
    }

    final result = <EnvelopeSuggestion>[];
    for (final entry in byCategory.entries) {
      final months = entry.value;
      if (months.length < minMonthsForEnvelope) continue;

      final total = months.values.fold(0, (a, b) => a + b);
      final average = total ~/ months.length;
      if (average <= 0) continue;

      result.add(
        EnvelopeSuggestion(
          categoryId: entry.key,
          average: Money(average),
          suggestedLimit: Money(_roundUpToHuman(average)),
          months: months.length,
        ),
      );
    }

    result.sort((a, b) => b.average.cents.compareTo(a.average.cents));
    return result;
  }

  /// Adds ~10 % headroom then rounds up to a figure a person would pick: the
  /// next 10 € under 200 €, the next 50 € above.
  static int _roundUpToHuman(int cents) {
    final withHeadroom = (cents * 1.1).round();
    final step = withHeadroom < 20000 ? 1000 : 5000;
    return ((withHeadroom + step - 1) ~/ step) * step;
  }
}
