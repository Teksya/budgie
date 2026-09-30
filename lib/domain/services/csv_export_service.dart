import 'dart:io';

import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/transaction_repository.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Exports one budget month as a spreadsheet-friendly CSV.
///
/// Deliberately one-way. The CSV *import* was dropped as too technical for a
/// consumer app (see SPEC), but exporting is a different need: expense claims,
/// a shared flat, an accountant, or simply owning your own data.
class CsvExportService {
  const CsvExportService(this._db);

  final AppDatabase _db;

  /// Writes the transactions of [period] to a temporary file and hands it to
  /// the OS share sheet. Returns false if the month held nothing.
  Future<bool> exportPeriod(L l, Period period) async {
    final rows = await _rowsFor(period);
    if (rows.isEmpty) return false;

    final range = PeriodRange(period.startDate, period.endDate);
    final csv = _toCsv(l, rows);

    final dir = await getTemporaryDirectory();
    // The month in the filename, sortable and free of separators that would
    // upset a file manager.
    final stamp = DateFormat('yyyy-MM').format(period.startDate);
    final file = File('${dir.path}/budgie-$stamp.csv');
    // A BOM so Excel opens UTF-8 accents correctly instead of mojibake.
    await file.writeAsString('﻿$csv');

    await SharePlus.instance.share(
      ShareParams(files: [XFile(file.path)], subject: l.exportSubject(range.label)),
    );
    return true;
  }

  Future<List<TxnView>> _rowsFor(Period period) =>
      TransactionRepository(_db).watchForPeriod(period.id).first;

  String _toCsv(L l, List<TxnView> rows) {
    final date = DateFormat('yyyy-MM-dd');
    final buffer = StringBuffer()
      ..writeln(
        [
          l.csvDate,
          l.csvType,
          l.csvCategory,
          l.csvAccount,
          l.csvNote,
          l.csvAmount,
        ].map(_escape).join(';'),
      );

    for (final row in rows) {
      final txn = row.txn;
      // Expenses negative, income positive: the sign is what a spreadsheet
      // needs to total a column without further thought.
      final signed = txn.type == TxnType.income
          ? Money(txn.amountCents)
          : -Money(txn.amountCents);
      buffer.writeln(
        [
          date.format(txn.date),
          txn.type.name,
          row.category?.name ?? l.uncategorized,
          row.account?.name ?? '',
          txn.note ?? '',
          // Raw decimal, not the formatted amount: no currency symbol and no
          // thousands separator, or the cell stops being a number.
          (signed.cents / 100).toStringAsFixed(2),
        ].map(_escape).join(';'),
      );
    }
    return buffer.toString();
  }

  /// Semicolon-separated, because that is what a French Excel expects; fields
  /// are quoted whenever they could otherwise break the row.
  static String _escape(String value) {
    if (!value.contains(RegExp('[";\n\r]'))) return value;
    return '"${value.replaceAll('"', '""')}"';
  }
}
