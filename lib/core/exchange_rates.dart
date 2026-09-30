import 'package:budget/core/money.dart';
import 'package:meta/meta.dart';

/// User-entered conversion rates, keyed by ISO currency code.
///
/// The app never goes online, so there is no such thing as *the* rate here —
/// only the one the user typed. That is a deliberate trade: an offline app that
/// invents a rate is worse than one that asks for it and says so.
///
/// A rate is **how much of the main currency one unit is worth**: `USD → 0.92`
/// reads as "1 USD = 0,92 EUR", which is the way a person says it out loud.
///
/// Only conversion *at entry* uses these. Transactions are stored in the main
/// currency, so editing a rate never rewrites past months — a budget whose
/// history moved every time you corrected a rate would be unusable.
@immutable
class ExchangeRates {
  const ExchangeRates(this._byCode);

  /// Reads every `fx_rate_*` entry out of the raw settings map.
  factory ExchangeRates.fromSettings(Map<String, String> settings) {
    final rates = <String, double>{};
    for (final entry in settings.entries) {
      if (!entry.key.startsWith(keyPrefix)) continue;
      final value = double.tryParse(entry.value.replaceAll(',', '.'));
      if (value == null || value <= 0) continue;
      rates[entry.key.substring(keyPrefix.length).toUpperCase()] = value;
    }
    return ExchangeRates(rates);
  }

  static const empty = ExchangeRates({});

  /// Prefix of the settings keys holding the rates.
  static const keyPrefix = 'fx_rate_';

  final Map<String, double> _byCode;

  static String keyFor(String code) => '$keyPrefix${code.toUpperCase()}';

  /// The rate for [code], or null when the user has not given one. Null is the
  /// signal to ask rather than to guess.
  double? rateFor(String? code) =>
      code == null ? null : _byCode[code.toUpperCase()];

  bool get isEmpty => _byCode.isEmpty;

  Iterable<MapEntry<String, double>> get all =>
      _byCode.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

  /// [amount], expressed in [code], converted to the main currency.
  ///
  /// Returns [amount] unchanged when there is no rate to apply: the user gets
  /// their own figure rather than a silently wrong one.
  Money toMain(Money amount, String? code) {
    final rate = rateFor(code);
    if (rate == null) return amount;
    return Money((amount.cents * rate).round());
  }

  /// The reverse, for showing an account's balance in its own currency.
  Money fromMain(Money amount, String? code) {
    final rate = rateFor(code);
    if (rate == null || rate == 0) return amount;
    return Money((amount.cents / rate).round());
  }
}
