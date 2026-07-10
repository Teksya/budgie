import 'package:budget/core/money.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('fr_FR'));

  group('Money', () {
    test('stores cents exactly, unlike doubles', () {
      final a = Money.fromEuros(0.1);
      final b = Money.fromEuros(0.2);
      expect((a + b).cents, 30);
      // The reason this type exists:
      expect(0.1 + 0.2 == 0.3, isFalse);
    });

    test('rounds euros to the nearest cent', () {
      expect(Money.fromEuros(10.005).cents, 1001);
      expect(Money.fromEuros(10.004).cents, 1000);
    });

    test('arithmetic', () {
      expect((const Money(1000) - const Money(1500)).cents, -500);
      expect((const Money(250) * 3).cents, 750);
      expect((-const Money(250)).cents, -250);
      expect(const Money(-250).abs.cents, 250);
    });

    test('comparison', () {
      expect(const Money(100) < const Money(200), isTrue);
      expect(const Money(200) >= const Money(200), isTrue);
    });

    test('equality is by value', () {
      expect(const Money(100), const Money(100));
    });

    test('dividedBy rounds and never divides by zero', () {
      expect(const Money(1000).dividedBy(3).cents, 333);
      expect(const Money(100).dividedBy(0).cents, 100);
      expect(const Money(100).dividedBy(-5).cents, 100);
    });

    test('ratioOf clamps and survives a zero total', () {
      expect(const Money(50).ratioOf(const Money(100)), 0.5);
      expect(const Money(150).ratioOf(const Money(100)), 1.0);
      expect(const Money(50).ratioOf(Money.zero), 0.0);
    });

    test('sums an iterable', () {
      expect(
        [const Money(100), const Money(250), const Money(-50)].sum.cents,
        300,
      );
    });

    test('formats in French', () {
      // fr_FR separates thousands with a narrow no-break space (U+202F) and
      // precedes the symbol with a no-break space (U+00A0). Asserting the
      // property rather than pasting invisible characters into a literal:
      // a plain ASCII space here would mean intl changed its locale data.
      final s = const Money(123456).format();
      expect(s.replaceAll(RegExp('[  ]'), '_'), '1_234,56_€');
      expect(s.contains(' '), isFalse, reason: 'no plain space expected');
      expect(const Money(-50).format(), startsWith('-0,50'));
    });

    test('formatSigned uses a real minus sign', () {
      expect(const Money(-500).formatSigned().startsWith('−'), isTrue);
      expect(const Money(500).formatSigned().startsWith('+'), isTrue);
    });
  });
}
