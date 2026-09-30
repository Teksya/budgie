import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/domain/services/period_service.dart';
import 'package:budget/domain/services/recurrence_service.dart';
import 'package:drift/drift.dart';

/// One recurring charge or subscription the user set up during onboarding.
class OnboardingCharge {
  const OnboardingCharge({
    required this.name,
    required this.categoryName,
    required this.amountCents,
    required this.dueDay,
    this.isVariable = false,
    this.nature = RecurrenceNature.fixedCharge,
  });

  final String name;
  final String categoryName;
  final int amountCents;
  final int dueDay;
  final bool isVariable;
  final RecurrenceNature nature;
}

/// One spending cap the user set during onboarding.
class OnboardingEnvelope {
  const OnboardingEnvelope({required this.categoryId, required this.limitCents});

  final int categoryId;
  final int limitCents;
}

/// Turns the welcome-flow answers into real data, and provides the "try with
/// sample data" and "start over" actions.
class OnboardingService {
  OnboardingService(this._db)
    : _periods = PeriodService(_db),
      _recurrences = RecurrenceService(_db);

  final AppDatabase _db;
  final PeriodService _periods;
  final RecurrenceService _recurrences;

  Future<int?> _categoryId(String name) async {
    final row = await (_db.select(_db.categories)
          ..where((c) => c.name.equals(name))
          ..limit(1))
        .getSingleOrNull();
    return row?.id;
  }

  Future<int> _mainAccountId() async {
    final a = await (_db.select(_db.accounts)..limit(1)).getSingle();
    return a.id;
  }

  Future<Period> _openPeriod(int startDay) =>
      _periods.ensureOpenPeriodFor(DateTime.now(), startDay: startDay);

  Future<void> _setOnboarded() => _db
      .into(_db.settingsEntries)
      .insertOnConflictUpdate(
        SettingsEntriesCompanion.insert(
          key: SettingKeys.onboarded,
          value: 'true',
        ),
      );

  /// Applies the guided setup: period start day, recurring salary, fixed
  /// charges, subscriptions and spending caps, then marks onboarding done.
  Future<void> completeSetup({
    required int startDay,
    int? salaryCents,
    int salaryDay = 1,
    List<OnboardingCharge> charges = const [],
    List<OnboardingEnvelope> envelopes = const [],
  }) async {
    await _db.into(_db.settingsEntries).insertOnConflictUpdate(
      SettingsEntriesCompanion.insert(
        key: SettingKeys.periodStartDay,
        value: '$startDay',
      ),
    );

    final period = await _openPeriod(startDay);
    final accountId = await _mainAccountId();

    if (salaryCents != null && salaryCents > 0) {
      await _db.into(_db.recurrences).insert(
        RecurrencesCompanion.insert(
          name: 'Salaire',
          type: TxnType.income,
          nature: RecurrenceNature.salary,
          categoryId: Value(await _categoryId('Salaire')),
          accountId: accountId,
          estimatedAmountCents: salaryCents,
          frequency: Frequency.monthly,
          dueDayOfMonth: salaryDay,
          startDate: DateTime.now(),
        ),
      );
    }

    for (final c in charges) {
      if (c.amountCents <= 0) continue;
      await _db.into(_db.recurrences).insert(
        RecurrencesCompanion.insert(
          name: c.name,
          type: TxnType.expense,
          nature: c.nature,
          categoryId: Value(await _categoryId(c.categoryName)),
          accountId: accountId,
          estimatedAmountCents: c.amountCents,
          isVariable: Value(c.isVariable),
          frequency: Frequency.monthly,
          dueDayOfMonth: c.dueDay,
          startDate: DateTime.now(),
        ),
      );
    }

    await _recurrences.materialize(period);

    for (final e in envelopes) {
      if (e.limitCents <= 0) continue;
      await _db.into(_db.budgets).insert(
        BudgetsCompanion.insert(
          periodId: period.id,
          categoryId: e.categoryId,
          limitCents: e.limitCents,
        ),
        mode: InsertMode.insertOrIgnore,
      );
    }

    await _setOnboarded();
  }

  /// Erases everything and returns to a fresh, un-onboarded install.
  Future<void> resetAll() => _db.wipeAndReseed();
}
