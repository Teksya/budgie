import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/features/categories/category_editor_page.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final categories = ref.watch(categoriesProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.categories),
          bottom: TabBar(
            tabs: [Tab(text: l.expenses), Tab(text: l.income)],
          ),
        ),
        body: categories.when(
          loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 4),
        ),
          error: (e, _) => Center(child: Text(l.errorWith('$e'))),
          data: (all) => TabBarView(
            children: [
              _CategoryList(all: all, kind: CategoryKind.expense),
              _CategoryList(all: all, kind: CategoryKind.income),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryList extends ConsumerWidget {
  const _CategoryList({required this.all, required this.kind});

  final List<Category> all;
  final CategoryKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ofKind = all.where((c) => c.kind == kind).toList();
    final parents = ofKind.where((c) => c.parentId == null).toList();
    final childrenOf = <int, List<Category>>{};
    for (final c in ofKind) {
      if (c.parentId != null) {
        childrenOf.putIfAbsent(c.parentId!, () => []).add(c);
      }
    }

    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl * 4,
          ),
          children: [
            for (final parent in parents)
              _CategoryCard(
                parent: parent,
                children: childrenOf[parent.id] ?? const [],
              ),
          ],
        ),
        Positioned(
          right: AppSpacing.md,
          bottom: AppSpacing.lg,
          child: FloatingActionButton.extended(
            heroTag: 'add_${kind.name}',
            onPressed: () => openCategoryEditor(context, kind: kind),
            icon: const Icon(Icons.add),
            label: Text(L.of(context).category),
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  const _CategoryCard({required this.parent, required this.children});

  final Category parent;
  final List<Category> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: Column(
          children: [
            _CategoryRow(category: parent, isChild: false),
            for (final child in children) ...[
              const Divider(height: 1, indent: 64),
              _CategoryRow(category: child, isChild: true),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends ConsumerWidget {
  const _CategoryRow({required this.category, required this.isChild});

  final Category category;
  final bool isChild;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final color = Color(category.colorValue);
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: isChild ? AppSpacing.xl : AppSpacing.md,
        right: AppSpacing.xs,
      ),
      leading: CircleAvatar(
        radius: isChild ? 16 : 20,
        backgroundColor: color.withValues(alpha: 0.16),
        foregroundColor: color,
        child: Icon(iconFor(category.iconKey), size: isChild ? 16 : 20),
      ),
      title: Text(category.name),
      subtitle: category.isSystem ? Text(l.systemCategory) : null,
      trailing: PopupMenuButton<String>(
        onSelected: (value) => switch (value) {
          'edit' => openCategoryEditor(
            context,
            kind: category.kind,
            existing: category,
          ),
          'delete' => _confirmDelete(context, ref),
          _ => null,
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: 'edit', child: Text(l.edit)),
          if (!category.isSystem)
            PopupMenuItem(value: 'delete', child: Text(l.actionDelete)),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteNamedQuestion(category.name)),
        content: Text(l.deleteCategoryWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.actionDelete),
          ),
        ],
      ),
    );
    if (ok ?? false) {
      await ref.read(categoryRepositoryProvider).delete(category);
    }
  }
}
