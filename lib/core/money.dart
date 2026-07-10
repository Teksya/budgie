import 'package:budget/core/app_currency.dart';

/// An amount of money, stored as an integer number of cents.
///
/// Never represent money as a `double`: 0.1 + 0.2 != 0.3 in binary floating
/// point, and those errors accumulate across a month of transactions.
extension type const Money(int cents) {
  factory Money.fromEuros(num euros) => Money((euros * 100).round());

  static const Money zero = Money(0);

  double get euros => cents / 100;

  bool get isZero => cents == 0;
  bool get isNegative => cents < 0;
  bool get isPositive => cents > 0;

  Money get abs => Money(cents.abs());

  Money operator +(Money other) => Money(cents + other.cents);
  Money operator -(Money other) => Money(cents - other.cents);
  Money operator -() => Money(-cents);
  Money operator *(num factor) => Money((cents * factor).round());

  bool operator <(Money other) => cents < other.cents;
  bool operator <=(Money other) => cents <= other.cents;
  bool operator >(Money other) => cents > other.cents;
  bool operator >=(Money other) => cents >= other.cents;

  /// Splits the amount over [parts], rounding to the nearest cent.
  ///
  /// Used for "reste par jour". Guards against division by zero: the last day
  /// of a period has zero *remaining* days but still needs a figure.
  Money dividedBy(int parts) =>
      parts <= 0 ? this : Money((cents / parts).round());

  /// Ratio of this amount to [total], clamped to `[0, 1]`.
  /// Returns 0 when [total] is zero, so progress bars never produce NaN.
  double ratioOf(Money total) {
    if (total.cents == 0) return 0;
    return (cents / total.cents).clamp(0.0, 1.0);
  }

  /// `1 234,56 €` (symbol and separators follow the chosen currency/locale).
  String format() => AppCurrency.instance.full(euros);

  /// `1 235 €` — for dense UI where the cents are noise.
  String formatRounded() => AppCurrency.instance.rounded(euros);

  /// `+1 234,56 €` / `−1 234,56 €` (true minus sign, not a hyphen).
  String formatSigned() {
    if (isNegative) return '−${abs.format()}';
    return '+${format()}';
  }
}

extension MoneyIterable on Iterable<Money> {
  Money get sum => fold(Money.zero, (a, b) => a + b);
}
