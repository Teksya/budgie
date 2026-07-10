import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:drift/drift.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class AccountWithBalance {
  const AccountWithBalance({required this.account, required this.balance});

  final Account account;
  final Money balance;
}

class AccountRepository {
  const AccountRepository(this._db);

  final AppDatabase _db;

  /// Accounts with their live balance:
  /// `initial + received income − expenses + transfers in − transfers out`.
  /// Planned (unreceived) income is excluded — it is not in the account yet.
  Stream<List<AccountWithBalance>> watchWithBalances() {
    final accounts = (_db.select(_db.accounts)
          ..where((a) => a.archived.equals(false))
          ..orderBy([(a) => OrderingTerm.asc(a.sortOrder)]))
        .watch();
    final txns = _db.select(_db.transactions).watch();

    return Rx.combineLatest2(accounts, txns, (accs, all) {
      return accs.map((a) {
        var cents = a.initialBalanceCents;
        for (final t in all) {
          switch (t.type) {
            case TxnType.income:
              if (t.accountId == a.id &&
                  t.incomeStatus == IncomeStatus.received) {
                cents += t.amountCents;
              }
            case TxnType.expense:
              if (t.accountId == a.id) cents -= t.amountCents;
            case TxnType.transfer:
              if (t.accountId == a.id) cents -= t.amountCents;
              if (t.toAccountId == a.id) cents += t.amountCents;
          }
        }
        return AccountWithBalance(account: a, balance: Money(cents));
      }).toList();
    });
  }

  Future<int> add(AccountsCompanion entry) =>
      _db.into(_db.accounts).insert(entry);

  Future<void> update(Account account) =>
      _db.update(_db.accounts).replace(account);

  /// Deletes an account. Blocked when it is the last one, since every
  /// transaction needs somewhere to live.
  Future<bool> delete(Account account) async {
    final count = await _db.accounts.count().getSingle();
    if (count <= 1) return false;
    await (_db.delete(_db.accounts)..where((a) => a.id.equals(account.id)))
        .go();
    return true;
  }
}
