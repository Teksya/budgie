import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/period_service.dart';
import 'package:drift/drift.dart';

class FavoriteRepository {
  FavoriteRepository(this._db) : _periods = PeriodService(_db);

  final AppDatabase _db;
  final PeriodService _periods;

  Stream<List<Favorite>> watchAll() =>
      (_db.select(_db.favorites)
            ..orderBy([(f) => OrderingTerm.asc(f.sortOrder)]))
          .watch();

  Future<int> add(FavoritesCompanion entry) =>
      _db.into(_db.favorites).insert(entry);

  Future<void> delete(int id) =>
      (_db.delete(_db.favorites)..where((f) => f.id.equals(id))).go();

  /// Creates an expense from [favorite] in the open period. [amountCents]
  /// overrides the favorite's amount (used when the favorite asks for one).
  Future<void> spend(Favorite favorite, {int? amountCents}) async {
    final cents = amountCents ?? favorite.amountCents;
    if (cents == null || cents <= 0) return;

    final open = await (_db.select(_db.periods)
          ..where((p) => p.status.equalsValue(PeriodStatus.open))
          ..limit(1))
        .getSingleOrNull();
    if (open == null) return;

    final account = favorite.accountId ??
        (await (_db.select(_db.accounts)..limit(1)).getSingle()).id;

    await _db.into(_db.transactions).insert(
      TransactionsCompanion.insert(
        date: DateTime.now(),
        type: TxnType.expense,
        amountCents: cents,
        categoryId: Value(favorite.categoryId),
        accountId: account,
        periodId: open.id,
        note: Value(favorite.label),
      ),
    );
    await _periods.recomputeCarryOverFrom(open.id);
  }
}
