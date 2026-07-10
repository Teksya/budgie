import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/recurrence_service.dart';
import 'package:drift/drift.dart';

/// Owns the lifecycle of budget periods: opening the one the user is currently
/// in, and keeping the carry-over chain correct when the past is edited.
class PeriodService {
  PeriodService(this._db) : _recurrences = RecurrenceService(_db);

  final AppDatabase _db;
  final RecurrenceService _recurrences;

  /// Real money left at the end of a period: what actually sits in the
  /// accounts, ignoring money that is merely expected or merely due.
  ///
  /// ```text
  /// carryOverIn + incomes received − expenses
  /// ```
  /// Paying a charge is an expense, so paid charges are already included.
  /// Planned (unreceived) income and unpaid charges deliberately are not:
  /// the point of the carry-over is the true balance handed to next month.
  static Money closingBalance({
    required Money carryOverIn,
    required Money incomeReceived,
    required Money expenses,
  }) => carryOverIn + incomeReceived - expenses;

  /// Ensures a period exists and is `open` for [now], generating its charge
  /// instances. Idempotent — returns the current open period on every call.
  Future<Period> ensureOpenPeriodFor(
    DateTime now, {
    required int startDay,
  }) async {
    final range = periodContaining(now, startDay: startDay);

    final existing = await (_db.select(_db.periods)
          ..where((p) => p.startDate.equals(range.start)))
        .getSingleOrNull();

    final period = existing ?? await _createPeriod(range);

    // Close any period that the clock has moved past but which is still open.
    await _closeStalePeriods(before: range.start);

    if (period.status == PeriodStatus.closed) {
      await (_db.update(_db.periods)..where((p) => p.id.equals(period.id)))
          .write(const PeriodsCompanion(status: Value(PeriodStatus.open)));
    }

    await _recurrences.materialize(period);
    return (_db.select(_db.periods)
          ..where((p) => p.id.equals(period.id)))
        .getSingle();
  }

  Future<Period> _createPeriod(PeriodRange range) async {
    // Carry-over comes from the closing balance of whatever period precedes
    // this one in time.
    final previous = await (_db.select(_db.periods)
          ..where((p) => p.startDate.isSmallerThanValue(range.start))
          ..orderBy([(p) => OrderingTerm.desc(p.startDate)])
          ..limit(1))
        .getSingleOrNull();

    final carry = previous == null
        ? Money.zero
        : await _closingBalanceOf(previous);

    final id = await _db.into(_db.periods).insert(
          PeriodsCompanion.insert(
            startDate: range.start,
            endDate: range.endInclusive,
            status: PeriodStatus.open,
            carryOverInCents: Value(carry.cents),
          ),
        );

    if (previous != null) await _carryEnvelopes(previous, id);

    return (_db.select(_db.periods)..where((p) => p.id.equals(id))).getSingle();
  }

  /// Copies the previous period's envelopes into the new one. For an envelope
  /// flagged `rollover`, whatever went unspent is added on top of next month's
  /// limit; others simply reset.
  Future<void> _carryEnvelopes(Period previous, int newPeriodId) async {
    final budgets = await (_db.select(_db.budgets)
          ..where((b) => b.periodId.equals(previous.id)))
        .get();
    if (budgets.isEmpty) return;

    // Expenses of the previous period, once, to compute leftovers.
    final expenses = await (_db.select(_db.transactions)
          ..where(
            (t) =>
                t.periodId.equals(previous.id) &
                t.type.equalsValue(TxnType.expense),
          ))
        .get();
    final parentOf = {
      for (final c in await _db.select(_db.categories).get())
        if (c.parentId != null) c.id: c.parentId!,
    };

    Money spentOn(int categoryId) {
      var cents = 0;
      for (final t in expenses) {
        final cat = t.categoryId;
        if (cat == null) continue;
        if (cat == categoryId || parentOf[cat] == categoryId) {
          cents += t.amountCents;
        }
      }
      return Money(cents);
    }

    for (final b in budgets) {
      var rolloverIn = 0;
      if (b.rollover) {
        final available = b.limitCents + b.rolloverInCents;
        final left = available - spentOn(b.categoryId).cents;
        if (left > 0) rolloverIn = left;
      }
      await _db.into(_db.budgets).insert(
            BudgetsCompanion.insert(
              periodId: newPeriodId,
              categoryId: b.categoryId,
              limitCents: b.limitCents,
              rollover: Value(b.rollover),
              rolloverInCents: Value(rolloverIn),
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  Future<void> _closeStalePeriods({required DateTime before}) async {
    await (_db.update(_db.periods)
          ..where(
            (p) =>
                p.startDate.isSmallerThanValue(before) &
                p.status.equalsValue(PeriodStatus.open),
          ))
        .write(
          PeriodsCompanion(
            status: const Value(PeriodStatus.closed),
            closedAt: Value(DateTime.now()),
          ),
        );
  }

  /// Recomputes `carryOverIn` for every period at or after [fromPeriodId],
  /// in chronological order.
  ///
  /// Editing a transaction in an old month changes its closing balance, which
  /// is the next month's carry-over, and so on. A period whose
  /// [Period.carryOverManualCents] is set is a fixed point: it keeps its
  /// manual value and the cascade continues from there.
  Future<void> recomputeCarryOverFrom(int fromPeriodId) async {
    final from = await (_db.select(_db.periods)
          ..where((p) => p.id.equals(fromPeriodId)))
        .getSingleOrNull();
    if (from == null) return;

    final chain = await (_db.select(_db.periods)
          ..where((p) => p.startDate.isBiggerOrEqualValue(from.startDate))
          ..orderBy([(p) => OrderingTerm.asc(p.startDate)]))
        .get();

    await _db.transaction(() async {
      Money? runningCarry;
      for (final period in chain) {
        final carry = period.carryOverManualCents != null
            ? Money(period.carryOverManualCents!)
            : (runningCarry ?? Money(period.carryOverInCents));

        if (carry.cents != period.carryOverInCents) {
          await (_db.update(_db.periods)
                ..where((p) => p.id.equals(period.id)))
              .write(PeriodsCompanion(carryOverInCents: Value(carry.cents)));
        }

        final closing = await _closingBalanceOf(
          period.copyWith(carryOverInCents: carry.cents),
        );
        runningCarry = closing;
      }
    });
  }

  Future<Money> _closingBalanceOf(Period period) async {
    final carry = period.carryOverManualCents ?? period.carryOverInCents;

    final received = await _sumTransactions(
      period.id,
      TxnType.income,
      incomeStatus: IncomeStatus.received,
    );
    final expenses = await _sumTransactions(period.id, TxnType.expense);

    return closingBalance(
      carryOverIn: Money(carry),
      incomeReceived: received,
      expenses: expenses,
    );
  }

  Future<Money> _sumTransactions(
    int periodId,
    TxnType type, {
    IncomeStatus? incomeStatus,
  }) async {
    final amount = _db.transactions.amountCents.sum();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([amount])
      ..where(
        _db.transactions.periodId.equals(periodId) &
            _db.transactions.type.equalsValue(type),
      );
    if (incomeStatus != null) {
      query.where(_db.transactions.incomeStatus.equalsValue(incomeStatus));
    }
    final row = await query.getSingle();
    return Money(row.read(amount) ?? 0);
  }
}
