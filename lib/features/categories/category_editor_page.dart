import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/shared/icons.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _palette = [
  0xFF3D7EFF, 0xFF2E9E62, 0xFFE8A33D, 0xFFE05252, 0xFF8B5CF6,
  0xFF14A8A0, 0xFFE0559C, 0xFF5B5BD6, 0xFF9C6B3E, 0xFF6B7280,
  0xFF7CB342, 0xFFF2762E,
];

const _iconChoices = [
  'tag', 'cart', 'restaurant', 'home', 'car', 'fuel', 'health', 'fun',
  'shopping', 'school', 'plane', 'gift', 'sport', 'pets', 'bolt', 'water',
  'wifi', 'phone', 'receipt', 'subscription', 'insurance', 'salary', 'bonus',
  'piggy', 'target', 'more',
];

/// Opens the full-screen category editor. Pass [existing] to edit.
Future<void> openCategoryEditor(
  BuildContext context, {
  required CategoryKind kind,
  Category? existing,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => CategoryEditorPage(kind: kind, existing: existing),
  ),
);

class CategoryEditorPage extends ConsumerStatefulWidget {
  const CategoryEditorPage({required this.kind, this.existing, super.key});

  final CategoryKind kind;
  final Category? existing;

  @override
  ConsumerState<CategoryEditorPage> createState() =>
      _CategoryEditorPageState();
}

class _CategoryEditorPageState extends ConsumerState<CategoryEditorPage> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late String _iconKey = widget.existing?.iconKey ?? 'tag';
  late int _color = widget.existing?.colorValue ?? _palette.first;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final repo = ref.read(categoryRepositoryProvider);
    final existing = widget.existing;

    if (existing == null) {
      final order = await repo.nextSortOrder(widget.kind);
      await repo.add(
        CategoriesCompanion.insert(
          name: _name.text.trim(),
          kind: widget.kind,
          iconKey: Value(_iconKey),
          colorValue: _color,
          sortOrder: Value(order),
        ),
      );
    } else {
      await repo.update(
        existing.copyWith(
          name: _name.text.trim(),
          iconKey: _iconKey,
          colorValue: _color,
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Modifier la catégorie' : 'Nouvelle catégorie'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl * 2,
        ),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Color(_color).withValues(alpha: 0.18),
                foregroundColor: Color(_color),
                child: Icon(iconFor(_iconKey), size: 26),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _name,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(labelText: 'Nom'),
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Couleur', style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final c in _palette)
                _Swatch(
                  color: c,
                  selected: _color == c,
                  onTap: () => setState(() => _color = c),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Icône', style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final key in _iconChoices)
                _IconChoice(
                  iconKey: key,
                  color: _color,
                  selected: _iconKey == key,
                  onTap: () => setState(() => _iconKey = key),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: (_name.text.trim().isNotEmpty && !_saving) ? _save : null,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(editing ? 'Enregistrer' : 'Créer la catégorie'),
          ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final int color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Color(color),
          shape: BoxShape.circle,
          border: selected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 3,
                )
              : null,
        ),
        child: selected
            ? const Icon(Icons.check, color: Colors.white, size: 22)
            : null,
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.iconKey,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String iconKey;
  final int color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: selected
              ? Color(color).withValues(alpha: 0.20)
              : scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: selected ? Border.all(color: Color(color), width: 2) : null,
        ),
        child: Icon(
          iconFor(iconKey),
          color: selected ? Color(color) : scheme.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}
