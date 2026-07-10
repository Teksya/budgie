import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/shared/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sets or edits the monthly limit for one category's envelope.
class AddEnvelopePage extends ConsumerStatefulWidget {
  const AddEnvelopePage({this.initialCategoryId, this.initialLimitCents, super.key});

  final int? initialCategoryId;
  final int? initialLimitCents;

  @override
  ConsumerState<AddEnvelopePage> createState() => _AddEnvelopePageState();
}

class _AddEnvelopePageState extends ConsumerState<AddEnvelopePage> {
  late int? _categoryId = widget.initialCategoryId;
  late final _limit = TextEditingController(
    text: widget.initialLimitCents == null
        ? ''
        : (widget.initialLimitCents! / 100).toStringAsFixed(2),
  );
  bool _rollover = false;
  bool _saving = false;

  @override
  void dispose() {
    _limit.dispose();
    super.dispose();
  }

  Money? get _parsedLimit {
    final raw = _limit.text.trim().replaceAll(',', '.');
    final value = double.tryParse(raw);
    if (value == null || value <= 0) return null;
    return Money.fromEuros(value);
  }

  Future<void> _save() async {
    final limit = _parsedLimit;
    final categoryId = _categoryId;
    if (limit == null || categoryId == null) return;
    setState(() => _saving = true);

    final period = await ref.read(openPeriodProvider.future);
    await ref.read(envelopeRepositoryProvider).upsert(
      periodId: period.id,
      categoryId: categoryId,
      limitCents: limit.cents,
      rollover: _rollover,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Parent expense categories are the usual envelope targets.
    final categories = (ref.watch(categoriesProvider).value ?? const [])
        .where((c) => c.kind == CategoryKind.expense && c.parentId == null)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Enveloppe')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl * 2,
        ),
        children: [
          Text('Catégorie', style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final c in categories)
                ChoiceChip(
                  avatar: Icon(
                    iconFor(c.iconKey),
                    size: 18,
                    color: Color(c.colorValue),
                  ),
                  label: Text(c.name),
                  selected: _categoryId == c.id,
                  onSelected: (_) => setState(() => _categoryId = c.id),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _limit,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Plafond mensuel',
              suffixText: '€',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Reporter le non-dépensé'),
            subtitle: Text(
              "Ce qui n'est pas dépensé s'ajoute au plafond du mois suivant.",
              style: theme.textTheme.bodySmall,
            ),
            value: _rollover,
            onChanged: (v) => setState(() => _rollover = v),
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed:
                (_parsedLimit != null && _categoryId != null && !_saving)
                ? _save
                : null,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}
