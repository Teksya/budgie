import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/recurrence_service.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_db.dart';

/// A recurrence template with everything but the fields under test defaulted.
Recurrence rec({
  int id = 1,
  Frequency frequency = Frequency.monthly,
  int dueDayOfMonth = 5,
  DateTime? startDate,
  DateTime? endDate,
  bool active = true,
}) => Recurrence(
  id: id,
  name: 'Loyer',
  type: TxnType.expense,
  nature: RecurrenceNature.fixedCharge,
  categoryId: null,
  accountId: 1,
  estimatedAmountCents: 75000,
  isVariable: false,
  frequency: frequency,
  dueDayOfMonth: dueDayOfMonth,
  startDate: startDate ?? DateTime(2026),
  endDate: endDate,
  active: active,
);

void main() {
  group('dueDatesFor — monthly', () {
    test('one occurrence inside a calendar month', () {
      final dates = RecurrenceService.dueDatesFor(
        rec(dueDayOfMonth: 5),
        start: DateTime(2026, 7),
        endInclusive: DateTime(2026, 7, 31),
      );
      expect(dates, [DateTime(2026, 7, 5)]);
    });

    test('a period straddling two months catches the right occurrence', () {
      // Budget month 25 Jul → 24 Aug, rent due on the 5th → the 5 Aug one.
      final dates = RecurrenceService.dueDatesFor(
        rec(dueDayOfMonth: 5),
        start: DateTime(2026, 7, 25),
        endInclusive: DateTime(2026, 8, 24),
      );
      expect(dates, [DateTime(2026, 8, 5)]);
    });

    test('due day clamps to a short month', () {
      final dates = RecurrenceService.dueDatesFor(
        rec(dueDayOfMonth: 31),
        start: DateTime(2026, 2),
        endInclusive: DateTime(2026, 2, 28),
      );
      expect(dates, [DateTime(2026, 2, 28)]);
    });
  });

  group('dueDatesFor — phase and bounds', () {
    test('quarterly lands only on months in phase with the start', () {
      final r = rec(
        frequency: Frequency.quarterly,
        dueDayOfMonth: 10,
        startDate: DateTime(2026), // Jan → phase covers Jan, Apr, Jul, Oct
      );
      expect(
        RecurrenceService.dueDatesFor(
          r,
          start: DateTime(2026, 4),
          endInclusive: DateTime(2026, 4, 30),
        ),
        [DateTime(2026, 4, 10)],
        reason: 'April is 3 months after January',
      );
      expect(
        RecurrenceService.dueDatesFor(
          r,
          start: DateTime(2026, 5),
          endInclusive: DateTime(2026, 5, 31),
        ),
        isEmpty,
        reason: 'May is not in phase',
      );
    });

    test('a due day already past in the starting month still counts', () {
      final dates = RecurrenceService.dueDatesFor(
        rec(dueDayOfMonth: 5, startDate: DateTime(2026, 7, 20)),
        start: DateTime(2026, 7),
        endInclusive: DateTime(2026, 7, 31),
      );
      // Declared on the 20th, but the rent was due — and paid — on the 5th.
      // Skipping it left the first month with no charges and no salary, which
      // is what made a late-in-the-month signup open on "over budget".
      expect(dates, [DateTime(2026, 7, 5)]);
    });

    test('nothing before the period the start date falls in', () {
      final dates = RecurrenceService.dueDatesFor(
        rec(dueDayOfMonth: 5, startDate: DateTime(2026, 8, 3)),
        start: DateTime(2026, 7),
        endInclusive: DateTime(2026, 7, 31),
      );
      expect(dates, isEmpty, reason: 'August recurrence, July period');
    });

    test('nothing after the end date', () {
      final dates = RecurrenceService.dueDatesFor(
        rec(dueDayOfMonth: 5, endDate: DateTime(2026, 6, 30)),
        start: DateTime(2026, 7),
        endInclusive: DateTime(2026, 7, 31),
      );
      expect(dates, isEmpty);
    });

    test('annual charge only in its month', () {
      final r = rec(
        frequency: Frequency.annual,
        dueDayOfMonth: 15,
        startDate: DateTime(2025, 3, 15),
      );
      expect(
        RecurrenceService.dueDatesFor(
          r,
          start: DateTime(2026, 3),
          endInclusive: DateTime(2026, 3, 31),
        ),
        [DateTime(2026, 3, 15)],
      );
      expect(
        RecurrenceService.dueDatesFor(
          r,
          start: DateTime(2026, 4),
          endInclusive: DateTime(2026, 4, 30),
        ),
        isEmpty,
      );
    });
  });

  group('materialize', () {
    late AppDatabase db;

    setUp(() => db = newTestDb());
    tearDown(() => db.close());

    Future<Period> openPeriod() =>
        (db.select(db.periods)..limit(1)).getSingle();

    Future<int> addRecurrence({int day = 5}) => db.into(db.recurrences).insert(
      RecurrencesCompanion.insert(
        name: 'Loyer',
        type: TxnType.expense,
        nature: RecurrenceNature.fixedCharge,
        accountId: 1,
        estimatedAmountCents: 75000,
        frequency: Frequency.monthly,
        dueDayOfMonth: day,
        startDate: DateTime(2026),
      ),
    );

    test('creates one instance per due date', () async {
      await addRecurrence();
      final period = await openPeriod();

      final inserted = await RecurrenceService(db).materialize(period);

      expect(inserted, 1);
      final instances = await db.select(db.recurrenceInstances).get();
      expect(instances, hasLength(1));
      expect(instances.single.estimatedAmountCents, 75000);
      expect(instances.single.status, InstanceStatus.pending);
    });

    test('is idempotent — running twice inserts nothing new', () async {
      await addRecurrence();
      final period = await openPeriod();
      final service = RecurrenceService(db);

      final first = await service.materialize(period);
      final second = await service.materialize(period);

      expect(first, 1);
      expect(second, 0, reason: 'the unique index must block duplicates');
      expect(await db.select(db.recurrenceInstances).get(), hasLength(1));
    });

    test('skips inactive recurrences', () async {
      final id = await addRecurrence();
      await (db.update(db.recurrences)..where((r) => r.id.equals(id)))
          .write(const RecurrencesCompanion(active: Value(false)));
      final period = await openPeriod();

      expect(await RecurrenceService(db).materialize(period), 0);
    });
  });
}
