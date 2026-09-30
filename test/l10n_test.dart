import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Locale;

import 'package:budget/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the thing that silently breaks a translation: a key added to the
/// template (`app_fr.arb`) and forgotten in `app_en.arb`. `gen-l10n` only warns
/// about that, so nothing fails the build — the English app just shows French.
void main() {
  Map<String, dynamic> arb(String locale) =>
      jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
          as Map<String, dynamic>;

  // `@key` entries carry placeholder metadata, not translatable text.
  Set<String> keysOf(Map<String, dynamic> m) =>
      m.keys.where((k) => !k.startsWith('@')).toSet();

  test('every string exists in both languages', () {
    final fr = keysOf(arb('fr'));
    final en = keysOf(arb('en'));

    expect(fr.difference(en), isEmpty, reason: 'missing from app_en.arb');
    expect(en.difference(fr), isEmpty, reason: 'missing from app_fr.arb');
  });

  test('no string was left untranslated by copy-paste', () {
    final fr = arb('fr');
    final en = arb('en');

    // Words that really are spelled the same in both languages. Anything else
    // being identical means someone pasted the French in and moved on.
    const legitimatelyIdentical = {
      'actionOk', 'appTitle', 'catFreelance', 'catInternet', 'catShopping',
      'catSport', 'catTransport', 'csvDate', 'csvNote', 'csvType', 'date',
      'exportSubject', 'fieldType', 'languageEnglish', 'languageFrench',
      'navBudgets', 'navStats', 'navTransactions', 'ratesOneUnitEquals',
      'recurrenceVariable',
      'settingsNotifications', 'settingsOrganisation', 'total',
    };

    final suspicious = keysOf(fr)
        .where((k) => fr[k] == en[k])
        .where((k) => !legitimatelyIdentical.contains(k))
        .toList();

    expect(suspicious, isEmpty);
  });

  test('both locales load and actually differ', () async {
    final fr = await L.delegate.load(const Locale('fr'));
    final en = await L.delegate.load(const Locale('en'));

    expect(fr.remainingToSpend, 'Reste à vivre');
    expect(en.remainingToSpend, 'Left to spend');
    // Placeholders and plural forms survive the round trip in both languages.
    expect(fr.daysLeft(3), '3 jours restants');
    expect(fr.daysLeft(1), '1 jour restant');
    expect(en.daysLeft(3), '3 days left');
    expect(en.daysLeft(1), '1 day left');
  });
}
