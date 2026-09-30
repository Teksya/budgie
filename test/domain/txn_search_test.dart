import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/repositories/transaction_repository.dart';
import 'package:flutter_test/flutter_test.dart';

/// The transactions search used to look at the note and the category only,
/// so "how much was that again" — the commonest reason to search — never
/// worked.
void main() {
  TxnView view({String? note, String? category, String? account, int cents = 1250}) =>
      TxnView(
        txn: Txn(
          id: 1,
          date: DateTime(2026, 7, 8),
          type: TxnType.expense,
          amountCents: cents,
          accountId: 1,
          periodId: 1,
          note: note,
          createdAt: DateTime(2026, 7, 8),
        ),
        category: category == null
            ? null
            : Category(
                id: 2,
                name: category,
                kind: CategoryKind.expense,
                iconKey: 'tag',
                colorValue: 0,
                isSystem: false,
                archived: false,
                sortOrder: 0,
              ),
        account: account == null
            ? null
            : Account(
                id: 1,
                name: account,
                type: AccountType.checking,
                iconKey: 'bank',
                initialBalanceCents: 0,
                archived: false,
                sortOrder: 0,
                createdAt: DateTime(2026),
              ),
      );

  test('an empty query keeps everything', () {
    expect(view().matches('   '), isTrue);
  });

  test('finds by note, category and account', () {
    final v = view(note: 'Carrefour', category: 'Courses', account: 'Livret A');
    expect(v.matches('carre'), isTrue);
    expect(v.matches('COURSES'), isTrue);
    expect(v.matches('livret'), isTrue);
    expect(v.matches('essence'), isFalse);
  });

  test('finds by amount, whichever decimal mark is typed', () {
    final v = view(cents: 1250);
    expect(v.matches('12'), isTrue);
    expect(v.matches('12,50'), isTrue);
    expect(v.matches('12.50'), isTrue);
    expect(v.matches('12,5'), isTrue);
    expect(v.matches('13'), isFalse);
  });

  test('a round amount is found without typing the cents', () {
    expect(view(cents: 5000).matches('50'), isTrue);
    expect(view(cents: 5000).matches('50,00'), isTrue);
  });

  test('does not match a row that has nothing to match on', () {
    expect(view(cents: 999).matches('carrefour'), isFalse);
  });
}
