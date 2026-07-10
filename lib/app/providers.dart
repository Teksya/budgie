import 'package:budget/core/app_currency.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/data/repositories/account_repository.dart';
import 'package:budget/data/repositories/budget_repository.dart';
import 'package:budget/data/repositories/category_repository.dart';
import 'package:budget/data/repositories/charge_repository.dart';
import 'package:budget/data/repositories/debt_repository.dart';
import 'package:budget/data/repositories/envelope_repository.dart';
import 'package:budget/data/repositories/favorite_repository.dart';
import 'package:budget/data/repositories/goal_repository.dart';
import 'package:budget/data/repositories/history_repository.dart';
import 'package:budget/data/repositories/recurrence_repository.dart';
import 'package:budget/data/repositories/settings_repository.dart';
import 'package:budget/data/repositories/stats_repository.dart';
import 'package:budget/data/repositories/transaction_repository.dart';
import 'package:budget/domain/services/backup_service.dart';
import 'package:budget/domain/services/budget_engine.dart';
import 'package:budget/domain/services/onboarding_service.dart';
import 'package:budget/domain/services/period_service.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ── Repositories & services ────────────────────────────────────────────────

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);

final periodServiceProvider = Provider<PeriodService>(
  (ref) => PeriodService(ref.watch(databaseProvider)),
);

final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => TransactionRepository(ref.watch(databaseProvider)),
);

/// Expense count per category, for ordering the picker by what's actually used.
final categoryUsageProvider = StreamProvider<Map<int, int>>(
  (ref) => ref.watch(transactionRepositoryProvider).watchCategoryUsage(),
);

final favoriteRepositoryProvider = Provider<FavoriteRepository>(
  (ref) => FavoriteRepository(ref.watch(databaseProvider)),
);

final favoritesProvider = StreamProvider<List<Favorite>>(
  (ref) => ref.watch(favoriteRepositoryProvider).watchAll(),
);

final chargeRepositoryProvider = Provider<ChargeRepository>(
  (ref) => ChargeRepository(ref.watch(databaseProvider)),
);

final recurrenceRepositoryProvider = Provider<RecurrenceRepository>(
  (ref) => RecurrenceRepository(ref.watch(databaseProvider)),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepository(ref.watch(databaseProvider)),
);

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(ref.watch(databaseProvider)),
);

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(ref.watch(databaseProvider)),
);

final debtRepositoryProvider = Provider<DebtRepository>(
  (ref) => DebtRepository(ref.watch(databaseProvider)),
);

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(ref.watch(databaseProvider)),
);

final onboardingServiceProvider = Provider<OnboardingService>(
  (ref) => OnboardingService(ref.watch(databaseProvider)),
);

/// Null while settings load; then true/false. Drives the welcome flow.
final onboardedProvider = Provider<bool?>((ref) {
  final settings = ref.watch(settingsProvider).value;
  if (settings == null) return null;
  return settings.isOnboarded;
});

final debtsProvider = StreamProvider<List<Debt>>(
  (ref) => ref.watch(debtRepositoryProvider).watchAll(),
);

final accountsWithBalanceProvider = StreamProvider<List<AccountWithBalance>>(
  (ref) => ref.watch(accountRepositoryProvider).watchWithBalances(),
);

/// All periods, most recent first.
final periodsProvider = StreamProvider<List<Period>>(
  (ref) => ref.watch(historyRepositoryProvider).watchPeriods(),
);

/// Which month the history screen is looking at, by its start date. Null means
/// "the current period", resolved once data loads.
class SelectedPeriodStart extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;

  // A named method reads better than a setter at call sites
  // (`.select(date)` vs `.start = date`).
  // ignore: use_setters_to_change_properties
  void select(DateTime? start) => state = start;
}

final selectedPeriodStartProvider =
    NotifierProvider<SelectedPeriodStart, DateTime?>(SelectedPeriodStart.new);

/// The period row for the history screen's current selection, or null if no
/// period exists for that month yet.
final selectedPeriodProvider = Provider<Period?>((ref) {
  final periods = ref.watch(periodsProvider).value ?? const [];
  if (periods.isEmpty) return null;
  final selected = ref.watch(selectedPeriodStartProvider);
  if (selected == null) return periods.first; // most recent
  for (final p in periods) {
    if (p.startDate == selected) return p;
  }
  return null;
});

final periodSummaryProvider = StreamProvider<PeriodSummary?>((ref) {
  final period = ref.watch(selectedPeriodProvider);
  if (period == null) return Stream<PeriodSummary?>.value(null);
  return ref.watch(historyRepositoryProvider).watchSummary(period);
});

final selectedPeriodTransactionsProvider = StreamProvider<List<TxnView>>((ref) {
  final period = ref.watch(selectedPeriodProvider);
  if (period == null) return Stream<List<TxnView>>.value(const []);
  return ref.watch(transactionRepositoryProvider).watchForPeriod(period.id);
});

final recurrencesProvider = StreamProvider<List<Recurrence>>(
  (ref) => ref.watch(recurrenceRepositoryProvider).watchAll(),
);

// Annotating the family's type breaks call-site inference (it degrades to
// dynamic); the type args on the right already document it.
// ignore: specify_nonobvious_property_types
final chargeHistoryProvider =
    StreamProvider.family<List<RecurrenceInstance>, int>(
  (ref, recurrenceId) =>
      ref.watch(recurrenceRepositoryProvider).watchHistory(recurrenceId),
);

final budgetRepositoryProvider = Provider<BudgetRepository>(
  (ref) => BudgetRepository(ref.watch(databaseProvider)),
);

// ── Settings ───────────────────────────────────────────────────────────────

final settingsProvider = StreamProvider<Map<String, String>>(
  (ref) => ref.watch(settingsRepositoryProvider).watchAll(),
);

/// Falls back to sane defaults while the first database read is in flight, so
/// the UI never flashes an unthemed frame.
final themeModeProvider = Provider<ThemeMode>((ref) {
  final raw = ref.watch(settingsProvider).value?[SettingKeys.themeMode];
  return switch (raw) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
});

final useDynamicColorProvider = Provider<bool>(
  (ref) => ref.watch(settingsProvider).value?.useDynamicColor ?? true,
);

final periodStartDayProvider = Provider<int>(
  (ref) => ref.watch(settingsProvider).value?.periodStartDay ?? 1,
);

/// Reads the currency setting, reconfigures the global formatter and returns
/// the code. Watching this rebuilds amounts when the currency changes.
final currencyProvider = Provider<String>((ref) {
  final code = ref.watch(settingsProvider).value?.currency ?? 'EUR';
  final language = ref.watch(languageProvider);
  // Numbers follow the app language (grouping/decimal marks).
  AppCurrency.instance.configure(
    currencyCode: code,
    locale: language?.languageCode == 'en' ? 'en_US' : 'fr_FR',
  );
  return code;
});

/// The forced app locale, or null to follow the system language.
final languageProvider = Provider<Locale?>((ref) {
  final raw = ref.watch(settingsProvider).value?[SettingKeys.language];
  return switch (raw) {
    'fr' => const Locale('fr'),
    'en' => const Locale('en'),
    _ => null,
  };
});

// ── Periods ────────────────────────────────────────────────────────────────

/// Opens (or reuses) the period the user is currently in, materialising its
/// charges. Everything downstream keys off the period it emits.
final openPeriodProvider = FutureProvider<Period>((ref) {
  final startDay = ref.watch(periodStartDayProvider);
  return ref
      .watch(periodServiceProvider)
      .ensureOpenPeriodFor(DateTime.now(), startDay: startDay);
});

final currentPeriodRangeProvider = Provider<PeriodRange>(
  (ref) => periodContaining(
    DateTime.now(),
    startDay: ref.watch(periodStartDayProvider),
  ),
);

// ── Reference data ─────────────────────────────────────────────────────────

final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.categories)
        ..where((c) => c.archived.equals(false))
        ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
      .watch();
});

final accountsProvider = StreamProvider<List<Account>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.accounts)
        ..where((a) => a.archived.equals(false))
        ..orderBy([(a) => OrderingTerm.asc(a.sortOrder)]))
      .watch();
});

// ── Period-scoped data ─────────────────────────────────────────────────────

/// The live "reste à vivre" for the open period.
final snapshotProvider = StreamProvider<BudgetSnapshot>((ref) async* {
  final period = await ref.watch(openPeriodProvider.future);
  yield* ref
      .watch(budgetRepositoryProvider)
      .watchSnapshot(period: period, now: DateTime.now());
});

final transactionsProvider = StreamProvider<List<TxnView>>((ref) async* {
  final period = await ref.watch(openPeriodProvider.future);
  yield* ref.watch(transactionRepositoryProvider).watchForPeriod(period.id);
});

final chargesProvider = StreamProvider<List<RecurrenceInstance>>((ref) async* {
  final period = await ref.watch(openPeriodProvider.future);
  yield* ref.watch(chargeRepositoryProvider).watchForPeriod(period.id);
});

final envelopeRepositoryProvider = Provider<EnvelopeRepository>(
  (ref) => EnvelopeRepository(ref.watch(databaseProvider)),
);

final envelopesProvider = StreamProvider<List<EnvelopeView>>((ref) async* {
  final period = await ref.watch(openPeriodProvider.future);
  yield* ref.watch(envelopeRepositoryProvider).watchForPeriod(period.id);
});

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => GoalRepository(ref.watch(databaseProvider)),
);

final goalsProvider = StreamProvider<List<GoalView>>(
  (ref) => ref.watch(goalRepositoryProvider).watchGoals(),
);

final statsRepositoryProvider = Provider<StatsRepository>(
  (ref) => StatsRepository(ref.watch(databaseProvider)),
);

final categoryBreakdownProvider = StreamProvider<List<CategorySlice>>((
  ref,
) async* {
  final period = await ref.watch(openPeriodProvider.future);
  yield* ref.watch(statsRepositoryProvider).watchCategoryBreakdown(period.id);
});

final monthlySeriesProvider = StreamProvider<List<MonthPoint>>(
  (ref) => ref.watch(statsRepositoryProvider).watchMonthlySeries(),
);
