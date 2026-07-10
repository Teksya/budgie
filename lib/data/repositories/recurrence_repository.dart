import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/recurrence_service.dart';
import 'package:drift/drift.dart';

class RecurrenceRepository {
  RecurrenceRepository(this._db) : _service = RecurrenceService(_db);

  final AppDatabase _db;
  final RecurrenceService _service;

  Stream<List<Recurrence>> watchAll() =>
      (_db.select(_db.recurrences)
            ..orderBy([(r) => OrderingTerm.asc(r.dueDayOfMonth)]))
          .watch();

  /// Adds a template and immediately materialises it into the currently open
  /// period, so its charge shows up without waiting for next month.
  Future<int> add(RecurrencesCompanion entry) async {
    final id = await _db.into(_db.recurrences).insert(entry);
    final open = await (_db.select(_db.periods)
          ..where((p) => p.status.equalsValue(PeriodStatus.open))
          ..limit(1))
        .getSingleOrNull();
    if (open != null) await _service.materialize(open);
    return id;
  }

  /// Updates a template. Existing already-materialised instances are left as
  /// they are; the new values apply to future materialisations.
  Future<void> update(Recurrence recurrence) =>
      _db.update(_db.recurrences).replace(recurrence);

  /// Paid occurrences of [recurrenceId] with a known real amount, oldest
  /// first — the raw material for a variable charge's trend.
  Stream<List<RecurrenceInstance>> watchHistory(int recurrenceId) =>
      (_db.select(_db.recurrenceInstances)
            ..where(
              (i) =>
                  i.recurrenceId.equals(recurrenceId) &
                  i.actualAmountCents.isNotNull(),
            )
            ..orderBy([(i) => OrderingTerm.asc(i.dueDate)]))
          .watch();

  Future<void> setEstimate(int recurrenceId, int cents) =>
      (_db.update(_db.recurrences)..where((r) => r.id.equals(recurrenceId)))
          .write(RecurrencesCompanion(estimatedAmountCents: Value(cents)));

  Future<void> setActive(int id, {required bool active}) =>
      (_db.update(_db.recurrences)..where((r) => r.id.equals(id)))
          .write(RecurrencesCompanion(active: Value(active)));

  Future<void> delete(int id) =>
      (_db.delete(_db.recurrences)..where((r) => r.id.equals(id))).go();
}
