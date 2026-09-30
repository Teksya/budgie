import 'package:budget/core/date_x.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  setUpAll(initializeDateFormatting);

  // `date_x` deliberately passes no locale to `DateFormat`, so every label here
  // depends on this global — the same one `AppCurrency.configure` sets from the
  // language setting.
  setUp(() => Intl.defaultLocale = 'fr_FR');

  group('periodContaining, start day 1', () {
    test('covers the whole calendar month', () {
      final p = periodContaining(DateTime(2026, 7, 15), startDay: 1);
      expect(p.start, DateTime(2026, 7));
      expect(p.endInclusive, DateTime(2026, 7, 31));
      expect(p.totalDays, 31);
    });

    test('the 1st belongs to the period it opens', () {
      final p = periodContaining(DateTime(2026, 7), startDay: 1);
      expect(p.start, DateTime(2026, 7));
    });

    test('handles February in a leap year', () {
      final p = periodContaining(DateTime(2028, 2, 10), startDay: 1);
      expect(p.endInclusive, DateTime(2028, 2, 29));
      expect(p.totalDays, 29);
    });
  });

  group('periodContaining, start day 25', () {
    test('a date after the 25th opens the period', () {
      final p = periodContaining(DateTime(2026, 7, 28), startDay: 25);
      expect(p.start, DateTime(2026, 7, 25));
      expect(p.endInclusive, DateTime(2026, 8, 24));
    });

    test('a date before the 25th belongs to the previous period', () {
      final p = periodContaining(DateTime(2026, 7, 3), startDay: 25);
      expect(p.start, DateTime(2026, 6, 25));
      expect(p.endInclusive, DateTime(2026, 7, 24));
    });

    test('crosses the new year', () {
      final p = periodContaining(DateTime(2027, 1, 3), startDay: 25);
      expect(p.start, DateTime(2026, 12, 25));
      expect(p.endInclusive, DateTime(2027, 1, 24));
    });
  });

  group('periodContaining, start day 31', () {
    test('clamps to the last day of a short month', () {
      final p = periodContaining(DateTime(2026, 2, 15), startDay: 31);
      expect(p.start, DateTime(2026, 1, 31));
      expect(p.endInclusive, DateTime(2026, 2, 27));

      final next = p.next;
      expect(next.start, DateTime(2026, 2, 28));
      expect(next.endInclusive, DateTime(2026, 3, 30));
    });
  });

  group('navigation', () {
    test('next and previous are inverse', () {
      final p = periodContaining(DateTime(2026, 7, 10), startDay: 1);
      expect(p.next.previous, p);
    });

    test('periods tile without gap or overlap', () {
      final p = periodContaining(DateTime(2026, 7, 10), startDay: 25);
      expect(p.next.start, p.endInclusive.add(const Duration(days: 1)));
    });
  });

  group('day counting', () {
    final p = PeriodRange(DateTime(2026, 7), DateTime(2026, 7, 31));

    test('the last day of the period still counts as one remaining day', () {
      expect(p.daysRemainingFrom(DateTime(2026, 7, 31, 23, 59)), 1);
    });

    test('the first day has every day remaining', () {
      expect(p.daysRemainingFrom(DateTime(2026, 7)), 31);
      expect(p.daysElapsedFrom(DateTime(2026, 7)), 0);
    });

    test('ignores the time component', () {
      expect(p.daysRemainingFrom(DateTime(2026, 7, 10, 23, 59)), 22);
      expect(p.daysRemainingFrom(DateTime(2026, 7, 10, 0, 1)), 22);
    });

    test('clamps outside the period', () {
      expect(p.daysRemainingFrom(DateTime(2026, 8)), 0);
      expect(p.daysRemainingFrom(DateTime(2026, 6)), 31);
    });

    test('contains respects both inclusive bounds', () {
      expect(p.contains(DateTime(2026, 7, 1, 12)), isTrue);
      expect(p.contains(DateTime(2026, 7, 31, 23)), isTrue);
      expect(p.contains(DateTime(2026, 8)), isFalse);
    });
  });

  group('labels', () {
    test('a calendar month reads as a month name', () {
      final p = periodContaining(DateTime(2026, 7, 10), startDay: 1);
      expect(p.label, 'Juillet 2026');
    });

    test('an offset period shows both bounds', () {
      final p = periodContaining(DateTime(2026, 7, 28), startDay: 25);
      expect(p.label, contains('→'));
    });

    test('the language setting reaches month and day names', () {
      Intl.defaultLocale = 'en_US';
      final p = periodContaining(DateTime(2026, 7, 10), startDay: 1);
      expect(p.label, 'July 2026');
      expect(DateTime(2026, 7, 6).longDayLabel, 'Monday 6 July');
      expect(DateTime(2026, 7, 6).shortLabel, '6 Jul');
    });
  });

  test('daysInMonth', () {
    expect(daysInMonth(2026, 2), 28);
    expect(daysInMonth(2028, 2), 29);
    expect(daysInMonth(2026, 12), 31);
  });
}
