import 'package:budget/core/money.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// What a scanned receipt yielded. Every field is a best-effort guess the user
/// confirms — the scanner never commits anything on its own.
@immutable
class ReceiptScan {
  const ReceiptScan({
    required this.rawText,
    this.guess,
    this.date,
    this.amounts = const [],
  });

  /// The most likely total.
  final Money? guess;

  /// Every amount found on the receipt, biggest first — the user taps one.
  final List<Money> amounts;

  final DateTime? date;
  final String rawText;

  bool get hasText => rawText.trim().isNotEmpty;
}

/// On-device OCR of a receipt photo. Runs entirely on the phone (Google ML Kit
/// bundled model) — no network, no third party, nothing leaves the device.
class ReceiptScanner {
  final _recognizer = TextRecognizer();

  Future<ReceiptScan> scan(String imagePath) async {
    try {
      final input = InputImage.fromFilePath(imagePath);
      final result = await _recognizer.processImage(input);
      final text = result.text;

      final all = <int>{};
      for (final line in text.split('\n')) {
        for (final a in _amountsIn(line)) {
          all.add(a.cents);
        }
      }
      final amounts = (all.toList()..sort((a, b) => b.compareTo(a)))
          .map(Money.new)
          .toList();

      return ReceiptScan(
        rawText: text,
        amounts: amounts,
        guess: _guessTotal(text) ?? (amounts.isEmpty ? null : amounts.first),
        date: _guessDate(text),
      );
    } on Object catch (e) {
      debugPrint('ReceiptScanner.scan failed: $e');
      return const ReceiptScan(rawText: '');
    }
  }

  Future<void> dispose() => _recognizer.close();

  /// Finds the amount on a line mentioning a total keyword, if any.
  ///
  /// Both languages are always searched rather than keyed off the app's
  /// locale: a receipt is printed by the shop, not by the phone, so an English
  /// user in France still gets French tickets and vice versa.
  static Money? _guessTotal(String text) {
    const keywords = [
      'total',
      'net a payer',
      'net à payer',
      'a payer',
      'à payer',
      'montant du',
      'montant dû',
      'amount due',
      'balance due',
      'to pay',
    ];
    // Lines that carry a keyword but never the figure we want.
    const excluded = [
      'sous-total',
      'sous total',
      'subtotal',
      'sub-total',
      'sub total',
    ];
    Money? best;
    for (final line in text.split('\n')) {
      final lower = line.toLowerCase();
      if (excluded.any(lower.contains)) continue;
      if (keywords.any(lower.contains)) {
        for (final a in _amountsIn(line)) {
          if (best == null || a > best) best = a;
        }
      }
    }
    return best;
  }

  /// Amounts in many real-receipt shapes: `12,50` · `12.5` · `1 234,00` ·
  /// `12 € 50` · `12€50` · `12,50 €`. Tolerant on purpose — the user picks the
  /// right one from the list, so over-detecting is fine.
  static Iterable<Money> _amountsIn(String rawLine) sync* {
    // Normalise the euro-as-separator and stray spaces around separators.
    final line = rawLine
        .replaceAllMapped(
          RegExp(r'(\d)\s*€\s*(\d{2})\b'),
          (m) => '${m[1]},${m[2]}',
        )
        .replaceAllMapped(
          RegExp(r'(\d)\s*([.,])\s*(\d{1,2})\b'),
          (m) => '${m[1]}${m[2]}${m[3]}',
        );

    final re = RegExp(r'(\d{1,3}(?:[ . ]\d{3})+|\d+)[.,](\d{1,2})(?!\d)');
    for (final m in re.allMatches(line)) {
      final intPart = m.group(1)!.replaceAll(RegExp('[ . ]'), '');
      final decPart = m.group(2)!.padRight(2, '0');
      final value = double.tryParse('$intPart.$decPart');
      if (value != null && value > 0 && value < 100000) {
        yield Money.fromEuros(value);
      }
    }
  }

  /// Recognises `dd/mm/yyyy`, `dd-mm-yyyy`, `dd.mm.yyyy` (2- or 4-digit year).
  ///
  /// Day-first only. A US-style `03/14/2026` fails the month check and simply
  /// yields no guess rather than a wrong date, which is the right way round:
  /// the user confirms the date anyway, and a silently swapped day and month
  /// would be worse than an empty field.
  static DateTime? _guessDate(String text) {
    final re = RegExp(r'(\d{1,2})[/.\-](\d{1,2})[/.\-](\d{2,4})');
    for (final m in re.allMatches(text)) {
      final d = int.parse(m.group(1)!);
      final mo = int.parse(m.group(2)!);
      var y = int.parse(m.group(3)!);
      if (y < 100) y += 2000;
      if (d >= 1 && d <= 31 && mo >= 1 && mo <= 12 && y >= 2000 && y <= 2100) {
        return DateTime(y, mo, d);
      }
    }
    return null;
  }
}
