import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/data/db/setting_keys.dart';
import 'package:budget/domain/services/suggestion_engine.dart';
import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

/// What the app has noticed about the user's spending and could act on.
@immutable
class Suggestions {
  const Suggestions({required this.recurrences, required this.envelopes});

  static const none = Suggestions(recurrences: [], envelopes: []);

  final List<RecurrenceSuggestion> recurrences;
  final List<EnvelopeSuggestion> envelopes;

  bool get isEmpty => recurrences.isEmpty && envelopes.isEmpty;
}

class SuggestionRepository {
  const SuggestionRepository(this._db);

  final AppDatabase _db;

  /// How far back to look. Enough to see a quarterly habit, short enough that
  /// a spending pattern the user has since abandoned stops being suggested.
  static const int _monthsOfHistory = 6;

  /// Reads the history once and asks [SuggestionEngine] what it makes of it.
  ///
  /// A `Future`, not a `Stream`: this is an occasional nudge, not a live
  /// figure, and re-running the whole analysis on every keystroke would be
  /// wasteful for something the user sees once a month.
  Future<Suggestions> analyse() async {
    final periods =
        await (_db.select(_db.periods)
              ..orderBy([(p) => OrderingTerm.desc(p.startDate)])
              ..limit(_monthsOfHistory))
            .get();
    if (periods.length < SuggestionEngine.minMonthsForEnvelope) {
      return Suggestions.none;
    }

    final ids = periods.map((p) => p.id).toList();
    final expenses = await (_db.select(_db.transactions)
          ..where(
            (t) => t.type.equalsValue(TxnType.expense) & t.periodId.isIn(ids),
          ))
        .get();

    final samples = [
      for (final t in expenses)
        SpendingSample(
          periodId: t.periodId,
          date: t.date,
          amount: Money(t.amountCents),
          categoryId: t.categoryId,
          note: t.note,
        ),
    ];

    // Never suggest what already exists, or what the user has waved away.
    final tracked = (await _db.select(_db.recurrences).get())
        .map((r) => r.name.trim().toLowerCase())
        .toSet();
    final capped = (await (_db.select(_db.budgets)
              ..where((b) => b.periodId.isIn(ids)))
            .get())
        .map((b) => b.categoryId)
        .toSet();
    final dismissed = await _dismissed();

    return Suggestions(
      recurrences: SuggestionEngine.recurrences(
        samples,
        alreadyTracked: tracked,
      ).where((s) => !dismissed.contains(recurrenceKey(s))).toList(),
      envelopes: SuggestionEngine.envelopes(
        samples,
        alreadyCapped: capped,
      ).where((s) => !dismissed.contains(envelopeKey(s))).toList(),
    );
  }

  /// Stable identifiers for a suggestion the user has refused, so it does not
  /// come back next month. Kept in settings rather than a table: it is a short
  /// list of strings and deserves no schema of its own.
  static String recurrenceKey(RecurrenceSuggestion s) =>
      'r:${s.label.toLowerCase()}';
  static String envelopeKey(EnvelopeSuggestion s) => 'e:${s.categoryId}';

  Future<Set<String>> _dismissed() async {
    final row = await (_db.select(_db.settingsEntries)
          ..where((s) => s.key.equals(SettingKeys.dismissedSuggestions)))
        .getSingleOrNull();
    final raw = row?.value ?? '';
    return raw.split('\n').where((s) => s.isNotEmpty).toSet();
  }

  Future<void> dismiss(String key) async {
    final all = await _dismissed()
      ..add(key);
    await _db
        .into(_db.settingsEntries)
        .insert(
          SettingsEntriesCompanion.insert(
            key: SettingKeys.dismissedSuggestions,
            value: all.join('\n'),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  /// Turns a suggestion into a real recurrence, ready to edit like any other.
  Future<void> acceptRecurrence(RecurrenceSuggestion s, {required int accountId}) =>
      _db
          .into(_db.recurrences)
          .insert(
            RecurrencesCompanion.insert(
              name: s.label,
              type: TxnType.expense,
              nature: RecurrenceNature.subscription,
              categoryId: Value(s.categoryId),
              accountId: accountId,
              estimatedAmountCents: s.amount.cents,
              frequency: Frequency.monthly,
              dueDayOfMonth: s.dayOfMonth,
              // Today, not the first sighting: the past months already have
              // their expenses recorded and must not gain a duplicate charge.
              startDate: DateTime.now(),
            ),
          );

  Future<void> acceptEnvelope(EnvelopeSuggestion s, {required int periodId}) =>
      _db
          .into(_db.budgets)
          .insert(
            BudgetsCompanion.insert(
              periodId: periodId,
              categoryId: s.categoryId,
              limitCents: s.suggestedLimit.cents,
            ),
            mode: InsertMode.insertOrIgnore,
          );
}
