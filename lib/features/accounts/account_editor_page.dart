import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/labels.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _accountIcons = ['bank', 'wallet', 'cash', 'piggy', 'card'];
const _palette = [
  0xFF3D7EFF, 0xFF2E9E62, 0xFFE8A33D, 0xFF8B5CF6, 0xFF14A8A0, 0xFF6B7280,
];

Future<void> openAccountEditor(
  BuildContext context, {
  Account? existing,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    builder: (_) => AccountEditorPage(existing: existing),
  ),
);

class AccountEditorPage extends ConsumerStatefulWidget {
  const AccountEditorPage({this.existing, super.key});

  final Account? existing;

  @override
  ConsumerState<AccountEditorPage> createState() => _AccountEditorPageState();
}

class _AccountEditorPageState extends ConsumerState<AccountEditorPage> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _initial = TextEditingController(
    text: widget.existing == null
        ? ''
        : (widget.existing!.initialBalanceCents / 100).toStringAsFixed(2),
  );
  late AccountType _type = widget.existing?.type ?? AccountType.checking;
  late String _iconKey = widget.existing?.iconKey ?? 'bank';
  late int _color = widget.existing?.colorValue ?? _palette.first;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _initial.dispose();
    super.dispose();
  }

  Money get _initialBalance {
    final raw = _initial.text.trim().replaceAll(',', '.');
    return Money.fromEuros(double.tryParse(raw) ?? 0);
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) return;
    setState(() => _saving = true);
    final repo = ref.read(accountRepositoryProvider);
    final existing = widget.existing;

    if (existing == null) {
      await repo.add(
        AccountsCompanion.insert(
          name: _name.text.trim(),
          type: _type,
          initialBalanceCents: Value(_initialBalance.cents),
          iconKey: Value(_iconKey),
          colorValue: Value(_color),
        ),
      );
    } else {
      await repo.update(
        existing.copyWith(
          name: _name.text.trim(),
          type: _type,
          initialBalanceCents: _initialBalance.cents,
          iconKey: _iconKey,
          colorValue: Value(_color),
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Supprimer « ${widget.existing!.name} » ?'),
        content: const Text(
          'Les transactions de ce compte seront supprimées. '
          'Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (!(ok ?? false)) return;
    final deleted =
        await ref.read(accountRepositoryProvider).delete(widget.existing!);
    if (!mounted) return;
    if (deleted) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de supprimer le dernier compte.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? 'Modifier le compte' : 'Nouveau compte'),
        actions: [
          if (editing)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Supprimer',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl * 2,
        ),
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Nom',
              hintText: 'Compte courant, Livret A…',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _initial,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,-]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Solde initial',
              helperText: 'Le solde du compte au moment où tu commences',
              suffixText: '€',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Type', style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final t in AccountType.values)
                ChoiceChip(
                  label: Text(t.label),
                  selected: _type == t,
                  onSelected: (_) => setState(() => _type = t),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Icône', style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final key in _accountIcons)
                _Choice(
                  selected: _iconKey == key,
                  color: _color,
                  onTap: () => setState(() => _iconKey = key),
                  child: Icon(iconFor(key)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Couleur', style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final c in _palette)
                GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                      border: _color == c
                          ? Border.all(color: theme.colorScheme.onSurface, width: 3)
                          : null,
                    ),
                    child: _color == c
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
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
                : Text(editing ? 'Enregistrer' : 'Créer le compte'),
          ),
        ],
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.selected,
    required this.color,
    required this.onTap,
    required this.child,
  });

  final bool selected;
  final int color;
  final VoidCallback onTap;
  final Widget child;

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
        child: IconTheme(
          data: IconThemeData(
            color: selected ? Color(color) : scheme.onSurfaceVariant,
          ),
          child: child,
        ),
      ),
    );
  }
}
