import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:drift/drift.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class GoalView {
  const GoalView({required this.goal, required this.saved});

  final SavingsGoal goal;

  /// Total contributed so far, across every period.
  final Money saved;

  Money get target => Money(goal.targetCents);
  Money get remaining => target - saved;
  double get ratio => saved.ratioOf(target);
  bool get reached => saved >= target;
}

class GoalRepository {
  const GoalRepository(this._db);

  final AppDatabase _db;

  Stream<List<GoalView>> watchGoals() {
    final goals = (_db.select(_db.savingsGoals)
          ..where((g) => g.archived.equals(false)))
        .watch();
    final contributions = _db.select(_db.goalContributions).watch();

    return Rx.combineLatest2(goals, contributions, (gs, cs) {
      Money savedFor(int goalId) => cs
          .where((c) => c.goalId == goalId)
          .map((c) => Money(c.amountCents))
          .sum;
      return gs
          .map((g) => GoalView(goal: g, saved: savedFor(g.id)))
          .toList();
    });
  }

  Future<int> add(SavingsGoalsCompanion entry) =>
      _db.into(_db.savingsGoals).insert(entry);

  Future<void> update(SavingsGoal goal) =>
      _db.update(_db.savingsGoals).replace(goal);

  Future<void> archive(int id) =>
      (_db.update(_db.savingsGoals)..where((g) => g.id.equals(id)))
          .write(const SavingsGoalsCompanion(archived: Value(true)));

  /// Records a contribution toward [goalId] in [periodId].
  Future<void> contribute({
    required int goalId,
    required int periodId,
    required int amountCents,
    required DateTime date,
  }) => _db.into(_db.goalContributions).insert(
    GoalContributionsCompanion.insert(
      goalId: goalId,
      periodId: periodId,
      amountCents: amountCents,
      date: date,
    ),
  );
}
