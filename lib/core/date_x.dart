import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// A budget period: a "month" that does not have to start on the 1st.
///
/// Both bounds are inclusive and normalised to midnight.
@immutable
class PeriodRange {
  const PeriodRange(this.start, this.endInclusive);

  final DateTime start;
  final DateTime endInclusive;

  /// Total number of days in the period, both bounds counted.
  int get totalDays => endInclusive.difference(start).inDays + 1;

  /// Days left including [today] itself, so the last day still counts as one.
  /// Clamped to `[0, totalDays]`.
  int daysRemainingFrom(DateTime today) {
    final day = today.dateOnly;
    if (day.isBefore(start)) return totalDays;
    if (day.isAfter(endInclusive)) return 0;
    return endInclusive.difference(day).inDays + 1;
  }

  int daysElapsedFrom(DateTime today) => totalDays - daysRemainingFrom(today);

  bool contains(DateTime date) {
    final day = date.dateOnly;
    return !day.isBefore(start) && !day.isAfter(endInclusive);
  }

  /// `Juillet 2026` when aligned on the 1st, `25 juil. → 24 août 2026`
  /// otherwise.
  String get label {
    if (start.day == 1) {
      return _capitalize(DateFormat.yMMMM('fr_FR').format(start));
    }
    final from = DateFormat('d MMM', 'fr_FR').format(start);
    final to = DateFormat('d MMM y', 'fr_FR').format(endInclusive);
    return '$from → $to';
  }

  PeriodRange get next => periodContaining(
    endInclusive.add(const Duration(days: 1)),
    startDay: start.day,
  );

  PeriodRange get previous => periodContaining(
    start.subtract(const Duration(days: 1)),
    startDay: start.day,
  );

  @override
  bool operator ==(Object other) =>
      other is PeriodRange &&
      other.start == start &&
      other.endInclusive == endInclusive;

  @override
  int get hashCode => Object.hash(start, endInclusive);

  @override
  String toString() => 'PeriodRange($start → $endInclusive)';
}

/// The period that [date] falls into, for a budget month starting on
/// [startDay].
///
/// [startDay] is clamped to the length of each month, so a period starting on
/// the 31st begins on the 28th in February.
PeriodRange periodContaining(DateTime date, {required int startDay}) {
  final day = date.dateOnly;
  final anchorThisMonth = _clampDay(day.year, day.month, startDay);

  final DateTime start;
  if (!day.isBefore(anchorThisMonth)) {
    start = anchorThisMonth;
  } else {
    final prev = _addMonths(day.year, day.month, -1);
    start = _clampDay(prev.$1, prev.$2, startDay);
  }

  final afterStart = _addMonths(start.year, start.month, 1);
  final nextStart = _clampDay(afterStart.$1, afterStart.$2, startDay);
  return PeriodRange(start, nextStart.subtract(const Duration(days: 1)));
}

/// Number of days in [month] of [year].
int daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

DateTime _clampDay(int year, int month, int day) =>
    DateTime(year, month, day.clamp(1, daysInMonth(year, month)));

(int, int) _addMonths(int year, int month, int delta) {
  final total = year * 12 + (month - 1) + delta;
  return (total ~/ 12, total % 12 + 1);
}

String _capitalize(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

extension DateOnlyX on DateTime {
  /// Same calendar day, time zeroed. Comparing raw `DateTime`s that carry a
  /// time component is the most common source of off-by-one-day bugs.
  DateTime get dateOnly => DateTime(year, month, day);

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// `lundi 6 juillet`
  String get longDayLabel =>
      _capitalize(DateFormat('EEEE d MMMM', 'fr_FR').format(this));

  /// `6 juil.`
  String get shortLabel => DateFormat('d MMM', 'fr_FR').format(this);
}
