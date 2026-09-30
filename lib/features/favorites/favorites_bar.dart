import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One-tap "typical expenses". Tap a chip to log it instantly (fixed amount)
/// or after a quick amount prompt; the trailing chip creates a new favorite.
class FavoritesBar extends ConsumerWidget {
  const FavoritesBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final favorites = ref.watch(favoritesProvider).value ?? const [];
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.xs),
          child: Text(l.quickExpenses, style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          // A fixed 44 clips the chips as soon as the user scales text up; the
          // cap keeps the strip from eating the screen at the largest sizes.
          height: MediaQuery.textScalerOf(context).scale(44).clamp(44.0, 76.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final f in favorites) ...[
                _FavoriteChip(favorite: f),
                const SizedBox(width: AppSpacing.sm),
              ],
              ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: Text(l.newFavorite),
                onPressed: () => _createFavorite(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FavoriteChip extends ConsumerWidget {
  const _FavoriteChip({required this.favorite});

  final Favorite favorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = favorite.colorValue != null
        ? Color(favorite.colorValue!)
        : Theme.of(context).colorScheme.primary;
    final hasAmount = favorite.amountCents != null;

    return GestureDetector(
      onLongPress: () => _confirmDelete(context, ref),
      child: ActionChip(
        avatar: Icon(iconFor(favorite.iconKey), size: 18, color: color),
        label: Text(
          hasAmount
              ? '${favorite.label} · ${Money(favorite.amountCents!).format()}'
              : favorite.label,
        ),
        onPressed: () => _spend(context, ref),
      ),
    );
  }

  Future<void> _spend(BuildContext context, WidgetRef ref) async {
    var cents = favorite.amountCents;
    final l = L.of(context);
    if (cents == null) {
      cents = await _askAmount(context, favorite.label);
      if (cents == null) return;
    }
    await ref
        .read(favoriteRepositoryProvider)
        .spend(favorite, amountCents: cents);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.favoriteAdded(favorite.label))),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l = L.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteNamedQuestion(favorite.label)),
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
      await ref.read(favoriteRepositoryProvider).delete(favorite.id);
    }
  }
}

Future<int?> _askAmount(BuildContext context, String label) async {
  final l = L.of(context);
  final controller = TextEditingController();
  final money = await showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(label),
      content: TextField(
        controller: controller,
        autofocus: true,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
        decoration: InputDecoration(
          labelText: l.amount,
          suffixText: AppCurrency.instance.symbol,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.actionCancel),
        ),
        FilledButton(
          onPressed: () {
            final v = double.tryParse(
              controller.text.trim().replaceAll(',', '.'),
            );
            Navigator.pop(
              context,
              v == null || v <= 0 ? null : Money.fromEuros(v).cents,
            );
          },
          child: Text(l.actionAdd),
        ),
      ],
    ),
  );
  controller.dispose();
  return money;
}

Future<void> _createFavorite(BuildContext context, WidgetRef ref) async {
  final l = L.of(context);
  final categories = (ref.read(categoriesProvider).value ?? const [])
      .where((c) => c.kind == CategoryKind.expense && c.parentId != null)
      .toList();
  final labelController = TextEditingController();
  final amountController = TextEditingController();
  var categoryId = categories.isNotEmpty ? categories.first.id : null;

  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(l.newFavoriteTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: labelController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l.fieldName,
                  hintText: l.favoriteNameHint,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: l.amountOptional,
                  helperText: l.favoriteAmountHelp,
                  suffixText: AppCurrency.instance.symbol,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(l.category, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final c in categories)
                    ChoiceChip(
                      label: Text(c.name),
                      selected: categoryId == c.id,
                      onSelected: (_) => setState(() => categoryId = c.id),
                    ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.actionCreate),
          ),
        ],
      ),
    ),
  );

  if (saved ?? false) {
    final label = labelController.text.trim();
    if (label.isNotEmpty) {
      final category = categories.where((c) => c.id == categoryId).firstOrNull;
      final amount = double.tryParse(
        amountController.text.trim().replaceAll(',', '.'),
      );
      await ref
          .read(favoriteRepositoryProvider)
          .add(
            FavoritesCompanion.insert(
              label: label,
              categoryId: Value(categoryId),
              amountCents: Value(
                amount == null || amount <= 0
                    ? null
                    : Money.fromEuros(amount).cents,
              ),
              iconKey: Value(category?.iconKey ?? 'tag'),
              colorValue: Value(category?.colorValue),
            ),
          );
    }
  }
  labelController.dispose();
  amountController.dispose();
}
