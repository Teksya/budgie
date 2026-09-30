import 'package:budget/core/exchange_rates.dart';
import 'package:budget/core/money.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reads only the rate keys out of the settings map', () {
    final rates = ExchangeRates.fromSettings(const {
      'theme_mode': 'dark',
      'fx_rate_USD': '0.92',
      // Written with a comma, as a French keyboard produces.
      'fx_rate_gbp': '1,17',
    });

    expect(rates.rateFor('USD'), 0.92);
    expect(rates.rateFor('GBP'), 1.17, reason: 'case and comma both tolerated');
    expect(rates.rateFor('JPY'), isNull);
  });

  test('ignores rates that could only produce nonsense', () {
    final rates = ExchangeRates.fromSettings(const {
      'fx_rate_USD': 'abc',
      'fx_rate_CHF': '0',
      'fx_rate_SEK': '-1',
    });
    expect(rates.isEmpty, isTrue);
  });

  test('converts into the main currency', () {
    const rates = ExchangeRates({'USD': 0.92});
    expect(rates.toMain(Money.fromEuros(100), 'USD'), Money.fromEuros(92));
  });

  test('converts back for display in the account currency', () {
    const rates = ExchangeRates({'USD': 0.92});
    final native = rates.fromMain(Money.fromEuros(92), 'USD');
    expect(native, Money.fromEuros(100));
  });

  test('a missing rate leaves the amount alone rather than guessing', () {
    const rates = ExchangeRates.empty;
    expect(rates.toMain(Money.fromEuros(100), 'USD'), Money.fromEuros(100));
    expect(rates.fromMain(Money.fromEuros(100), 'USD'), Money.fromEuros(100));
  });

  test('the main currency needs no rate', () {
    const rates = ExchangeRates({'USD': 0.92});
    expect(rates.toMain(Money.fromEuros(100), null), Money.fromEuros(100));
    expect(rates.rateFor(null), isNull);
  });

  test('round trip stays within a cent', () {
    const rates = ExchangeRates({'USD': 0.917});
    final there = rates.toMain(Money.fromEuros(37.45), 'USD');
    final back = rates.fromMain(there, 'USD');
    expect((back.cents - Money.fromEuros(37.45).cents).abs(), lessThanOrEqualTo(1));
  });
}
