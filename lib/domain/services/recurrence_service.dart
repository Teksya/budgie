import 'package:budget/core/date_x.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:drift/drift.dart';

/// Turns recurrence templates into concrete instances for a given period.
///
/// The heavy lifting is [dueDatesFor], which is pure and unit-tested; the
/// database side ([materialize]) just persists what it returns and leans on
/// the `(recurrenceId, dueDate)` unique index to stay idempotent.
class RecurrenceService {
  const RecurrenceService(this._db);

  final AppDatabase _db;

  /// Every due date of [r] that falls within `[start, endInclusive]`.
  ///
  /// A recurrence occurs every [Frequency.monthStep] months, on
  /// [Recurrence.dueDayOfMonth], clamped to the length of each month (a charge
  /// due on the 31st falls on the 28th/29th in February). The phase — which
  /// months an every-N-months charge lands on — is anchored to
  /// [Recurrence.startDate], not to the period.
  ///
  /// [Recurrence.startDate] gates whole periods, not individual days: a rent
  /// declared on the 28th was already paid on the 5th, and the month's figures
  /// only make sense if that instance exists. Clipping on the exact day instead
  /// meant that signing up late in the month produced no salary and no charges
  /// at all, so the very first dashboard read "over budget".
  static List<DateTime> dueDatesFor(
    Recurrence r, {
    required DateTime start,
    required DateTime endInclusive,
  }) {
    final step = r.frequency.monthStep;
    final anchor = r.startDate.dateOnly;
    // The recurrence has not begun by the time this period ends.
    if (anchor.isAfter(endInclusive)) return const [];
    final anchorAbsMonth = anchor.year * 12 + (anchor.month - 1);
    final result = <DateTime>[];

    // A period spans at most two calendar months, so walking each month it
    // touches is enough. `due` is filtered against the exact window below, so
    // iterating whole months can't over-produce.
    final firstAbs = start.year * 12 + (start.month - 1);
    final lastAbs = endInclusive.year * 12 + (endInclusive.month - 1);

    for (var absMonth = firstAbs; absMonth <= lastAbs; absMonth++) {
      // Dart's `%` is non-negative for a positive divisor, so this is correct
      // even for months before the anchor.
      if ((absMonth - anchorAbsMonth) % step != 0) continue;

      final year = absMonth ~/ 12;
      final month = absMonth % 12 + 1;
      final day = r.dueDayOfMonth.clamp(1, daysInMonth(year, month));
      final due = DateTime(year, month, day);

      if (r.endDate != null && due.isAfter(r.endDate!.dateOnly)) continue;
      if (due.isBefore(start) || due.isAfter(endInclusive)) continue;

      result.add(due);
    }
    return result;
  }

  /// Creates the missing instances for [period]. Safe to call repeatedly:
  /// existing `(recurrenceId, dueDate)` rows are skipped, never duplicated.
  ///
  /// Returns the number of instances inserted.
  Future<int> materialize(Period period) async {
    final active = await (_db.select(_db.recurrences)
          ..where((r) => r.active.equals(true)))
        .get();

    var inserted = 0;
    await _db.transaction(() async {
      // Dates already materialised for this period, so the count we return
      // reflects real insertions. `INSERT OR IGNORE` alone can't tell us: on a
      // conflict it leaves last_insert_rowid untouched, so its return value
      // lies about whether a row was added.
      final existingCharges = await (_db.select(_db.recurrenceInstances)
            ..where((i) => i.periodId.equals(period.id)))
          .get();
      final seenCharges = {
        for (final i in existingCharges)
          if (i.recurrenceId != null) (i.recurrenceId!, i.dueDate),
      };

      // A recurring salary lands as a *planned income transaction*, tagged
      // with its recurrenceId so re-running never duplicates it.
      final existingIncomes = await (_db.select(_db.transactions)
            ..where(
              (t) =>
                  t.periodId.equals(period.id) &
                  t.recurrenceId.isNotNull(),
            ))
          .get();
      final seenIncomes = {
        for (final t in existingIncomes)
          if (t.recurrenceId != null) t.recurrenceId!,
      };

      for (final r in active) {
        final dates = dueDatesFor(
          r,
          start: period.startDate,
          endInclusive: period.endDate,
        );

        if (r.type == TxnType.income) {
          // One income per period is the sane case; take the first due date.
          if (dates.isEmpty || seenIncomes.contains(r.id)) continue;
          await _db.into(_db.transactions).insert(
                TransactionsCompanion.insert(
                  date: dates.first,
                  type: TxnType.income,
                  amountCents: r.estimatedAmountCents,
                  categoryId: Value(r.categoryId),
                  accountId: r.accountId,
                  periodId: period.id,
                  note: Value(r.name),
                  incomeStatus: const Value(IncomeStatus.planned),
                  recurrenceId: Value(r.id),
                ),
              );
          seenIncomes.add(r.id);
          inserted++;
          continue;
        }

        for (final due in dates) {
          if (seenCharges.contains((r.id, due))) continue;
          await _db.into(_db.recurrenceInstances).insert(
                RecurrenceInstancesCompanion.insert(
                  recurrenceId: Value(r.id),
                  periodId: period.id,
                  label: r.name,
                  dueDate: due,
                  estimatedAmountCents: r.estimatedAmountCents,
                  status: InstanceStatus.pending,
                ),
                mode: InsertMode.insertOrIgnore,
              );
          seenCharges.add((r.id, due));
          inserted++;
        }
      }
    });
    return inserted;
  }
}
