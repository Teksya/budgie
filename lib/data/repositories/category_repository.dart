import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:drift/drift.dart';

class CategoryRepository {
  const CategoryRepository(this._db);

  final AppDatabase _db;

  Future<int> add(CategoriesCompanion entry) =>
      _db.into(_db.categories).insert(entry);

  Future<void> update(Category category) =>
      _db.update(_db.categories).replace(category);

  /// Deletes a category. Its transactions fall back to "Non catégorisé" (the
  /// FK is `onDelete: setNull`, and the UI renders a null category that way),
  /// and any sub-categories cascade away. System categories are protected.
  Future<bool> delete(Category category) async {
    if (category.isSystem) return false;
    await (_db.delete(_db.categories)..where((c) => c.id.equals(category.id)))
        .go();
    return true;
  }

  /// Next free sort order, so a new category lands at the end of its kind.
  Future<int> nextSortOrder(CategoryKind kind) async {
    final maxOrder = _db.categories.sortOrder.max();
    final row = await (_db.selectOnly(_db.categories)
          ..addColumns([maxOrder])
          ..where(_db.categories.kind.equalsValue(kind)))
        .getSingleOrNull();
    return (row?.read(maxOrder) ?? 0) + 1;
  }
}
