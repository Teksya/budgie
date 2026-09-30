import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/stats_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_db.dart';

/// The dashboard's "12 % less than last month" line. The whole point is the
/// window: comparing eight days of this month against a full previous month
/// would flatter the user every time.
void main() {
  late AppDatabase db;
  late StatsRepository stats;
  late int accountId;

  setUp(() async {
    db = newTestDb();
    stats = StatsRepository(db);
    accountId = (await db.select(db.accounts).getSingle()).id;
    // The seed opens a period for "today"; these tests want fixed dates.
    await db.delete(db.periods).go();
  });

  tearDown(() => db.close());

  Future<int> period(DateTime start, DateTime end) =>
      db.into(db.periods).insert(
        PeriodsCompanion.insert(
          startDate: start,
          endDate: end,
          status: PeriodStatus.closed,
        ),
      );

  Future<void> spend(int periodId, DateTime date, double euros) =>
      db.into(db.transactions).insert(
        TransactionsCompanion.insert(
          date: date,
          type: TxnType.expense,
          amountCents: Money.fromEuros(euros).cents,
          accountId: accountId,
          periodId: periodId,
        ),
      );

  test('measures the previous month over the same number of days', () async {
    final june = await period(DateTime(2026, 6), DateTime(2026, 6, 30));
    final july = await period(DateTime(2026, 7), DateTime(2026, 7, 31));

    // June: 100 € inside the first ten days, 900 € after them.
    await spend(june, DateTime(2026, 6, 3), 60);
    await spend(june, DateTime(2026, 6, 10), 40);
    await spend(june, DateTime(2026, 6, 25), 900);
    // July, up to the 10th: 80 €.
    await spend(july, DateTime(2026, 7, 8), 80);

    final result = await stats
        .watchSpendingComparison(
          period: (await db.select(db.periods).get()).firstWhere(
            (p) => p.id == july,
          ),
          now: DateTime(2026, 7, 10),
        )
        .first;

    expect(result, isNotNull);
    expect(result!.current, Money.fromEuros(80));
    expect(
      result.previous,
      Money.fromEuros(100),
      reason: 'the 900 € spent on 25 June is outside the first ten days',
    );
    expect(result.ratio, closeTo(-0.2, 0.0001));
  });

  test('is null without a previous period to compare against', () async {
    final july = await period(DateTime(2026, 7), DateTime(2026, 7, 31));
    await spend(july, DateTime(2026, 7, 8), 80);

    final result = await stats
        .watchSpendingComparison(
          period: await (db.select(db.periods)
                ..where((p) => p.id.equals(july)))
              .getSingle(),
          now: DateTime(2026, 7, 10),
        )
        .first;

    expect(result, isNull);
  });

  test('no ratio when last month spent nothing, so nothing is claimed', () async {
    await period(DateTime(2026, 6), DateTime(2026, 6, 30));
    final july = await period(DateTime(2026, 7), DateTime(2026, 7, 31));
    await spend(july, DateTime(2026, 7, 2), 50);

    final result = await stats
        .watchSpendingComparison(
          period: await (db.select(db.periods)
                ..where((p) => p.id.equals(july)))
              .getSingle(),
          now: DateTime(2026, 7, 3),
        )
        .first;

    expect(result!.previous, Money.zero);
    expect(result.ratio, isNull, reason: 'dividing by an empty month is a lie');
  });
}
