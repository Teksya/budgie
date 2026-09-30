import 'package:intl/intl.dart';

/// Currencies offered in settings: code → display symbol.
const Map<String, String> kCurrencies = {
  'EUR': '€',
  'USD': r'$',
  'GBP': '£',
  'CHF': 'CHF',
  'CAD': r'$',
  'AUD': r'$',
  'JPY': '¥',
  'SEK': 'kr',
  'NOK': 'kr',
  'DKK': 'kr',
};

/// Currencies with no minor unit (no cents shown).
const Set<String> kZeroDecimalCurrencies = {'JPY'};

/// Holds the active currency/locale used by `Money` formatting. Kept as a
/// mutable global so amount formatting stays dependency-free while still
/// reacting to the user's choice — call [configure] on startup and on change.
class AppCurrency {
  AppCurrency._();
  static final AppCurrency instance = AppCurrency._();

  String code = 'EUR';
  NumberFormat _full = NumberFormat.currency(locale: 'fr_FR', symbol: '€');
  NumberFormat _rounded = NumberFormat.currency(
    locale: 'fr_FR',
    symbol: '€',
    decimalDigits: 0,
  );

  void configure({required String currencyCode, required String locale}) {
    code = currencyCode;
    // Dates go through `DateFormat` with no explicit locale (see `date_x.dart`),
    // so this is also what makes month and day names follow the app language.
    Intl.defaultLocale = locale;
    final symbol = kCurrencies[currencyCode] ?? currencyCode;
    final decimals = kZeroDecimalCurrencies.contains(currencyCode) ? 0 : 2;
    _full = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimals,
    );
    _rounded = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 0,
    );
  }

  /// The symbol on its own, for the `suffixText` of amount fields — those are
  /// raw number inputs, so they cannot go through [full].
  String get symbol => kCurrencies[code] ?? code;

  String full(double value) => _full.format(value);
  String rounded(double value) => _rounded.format(value);
}
