import 'package:budget/data/db/database.dart';
import 'package:drift/native.dart';

/// A fresh in-memory database for a single test.
///
/// `onCreate` runs the full seed, so every test starts with the default
/// categories, a "Principal" account, and the current period already open —
/// the same state the app has on a user's first launch.
AppDatabase newTestDb() =>
    AppDatabase.forTesting(NativeDatabase.memory());
