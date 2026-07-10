import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/domain/services/period_service.dart';
import 'package:drift/drift.dart';

/// A transaction joined with the labels the UI needs, so the list does not
/// issue a query per row.
class TxnView {
  const TxnView({required this.txn, this.category, this.account});

  final Txn txn;
  final Category? category;
  final Account? account;
}

class TransactionRepository {
  TransactionRepository(this._db) : _periods = PeriodService(_db);

  final AppDatabase _db;
  final PeriodService _periods;

  Stream<List<TxnView>> watchForPeriod(int periodId) {
    final query = _db.select(_db.transactions).join([
      leftOuterJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.transactions.categoryId),
      ),
      leftOuterJoin(
        _db.accounts,
        _db.accounts.id.equalsExp(_db.transactions.accountId),
      ),
    ])
      ..where(_db.transactions.periodId.equals(periodId))
      ..orderBy([
        OrderingTerm.desc(_db.transactions.date),
        OrderingTerm.desc(_db.transactions.id),
      ]);

    return query.watch().map(
      (rows) => rows
          .map(
            (r) => TxnView(
              txn: r.readTable(_db.transactions),
              category: r.readTableOrNull(_db.categories),
              account: r.readTableOrNull(_db.accounts),
            ),
          )
          .toList(),
    );
  }

  /// Adds a transaction and refreshes the carry-over chain from its period,
  /// so an entry dated in a past month reflows into the present.
  Future<void> add(TransactionsCompanion entry) async {
    await _db.into(_db.transactions).insert(entry);
    if (entry.periodId.present) {
      await _periods.recomputeCarryOverFrom(entry.periodId.value);
    }
  }

  Future<void> update(Txn txn) async {
    await _db.update(_db.transactions).replace(txn);
    await _periods.recomputeCarryOverFrom(txn.periodId);
  }

  /// Adjusts a transaction's amount (and, for income, its received/planned
  /// status) — e.g. the salary landed for a different amount than planned.
  Future<void> editAmountAndStatus(
    Txn txn, {
    required int amountCents,
    IncomeStatus? incomeStatus,
  }) async {
    await (_db.update(_db.transactions)..where((t) => t.id.equals(txn.id)))
        .write(
      TransactionsCompanion(
        amountCents: Value(amountCents),
        incomeStatus: Value(incomeStatus),
      ),
    );
    await _periods.recomputeCarryOverFrom(txn.periodId);
  }

  Future<void> delete(Txn txn) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(txn.id)))
        .go();
    await _periods.recomputeCarryOverFrom(txn.periodId);
  }

  /// How many expenses each category has — used to float the categories a user
  /// actually picks to the front of the list.
  Stream<Map<int, int>> watchCategoryUsage() =>
      (_db.select(_db.transactions)
            ..where((t) => t.type.equalsValue(TxnType.expense)))
          .watch()
          .map((rows) {
            final counts = <int, int>{};
            for (final t in rows) {
              final c = t.categoryId;
              if (c != null) counts[c] = (counts[c] ?? 0) + 1;
            }
            return counts;
          });

  /// Guesses a category from a note by matching it against past expenses with
  /// a similar note (e.g. typing "Carrefour" recalls the category you used last
  /// time). Returns the most frequent match, or null.
  Future<int?> guessCategory(String note) async {
    final needle = note.trim().toLowerCase();
    if (needle.length < 3) return null;
    final rows = await (_db.select(_db.transactions)
          ..where(
            (t) =>
                t.type.equalsValue(TxnType.expense) & t.note.isNotNull(),
          ))
        .get();

    final counts = <int, int>{};
    for (final t in rows) {
      final n = t.note?.trim().toLowerCase();
      if (n == null || n.isEmpty || t.categoryId == null) continue;
      if (n.contains(needle) || needle.contains(n)) {
        counts[t.categoryId!] = (counts[t.categoryId!] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }
}
