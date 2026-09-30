import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/l10n/app_localizations.dart';
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
  late String? _currency = widget.existing?.currencyCode;
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
          currencyCode: Value(_currency),
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
          currencyCode: Value(_currency),
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    final l = L.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.deleteNamedQuestion(widget.existing!.name)),
        content: Text(l.deleteAccountWarning),
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
    if (!(ok ?? false)) return;
    final deleted =
        await ref.read(accountRepositoryProvider).delete(widget.existing!);
    if (!mounted) return;
    if (deleted) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l.cannotDeleteLastAccount)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final editing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? l.editAccount : l.newAccount),
        actions: [
          if (editing)
            IconButton(
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline),
              tooltip: l.actionDelete,
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
            decoration: InputDecoration(
              labelText: l.fieldName,
              hintText: l.accountNameHint,
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
            decoration: InputDecoration(
              labelText: l.initialBalance,
              helperText: l.initialBalanceHelp,
              suffixText: AppCurrency.instance.symbol,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l.fieldType, style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final t in AccountType.values)
                ChoiceChip(
                  label: Text(t.label(l)),
                  selected: _type == t,
                  onSelected: (_) => setState(() => _type = t),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l.accountCurrency, style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              // Null is "the app's currency" — the case for almost everyone,
              // so it leads and is selected by default.
              ChoiceChip(
                label: Text(
                  l.accountCurrencySameAsApp(AppCurrency.instance.code),
                ),
                selected: _currency == null,
                onSelected: (_) => setState(() => _currency = null),
              ),
              for (final code in kCurrencies.keys)
                if (code != AppCurrency.instance.code)
                  ChoiceChip(
                    label: Text(code),
                    selected: _currency == code,
                    onSelected: (_) => setState(() => _currency = code),
                  ),
            ],
          ),
          if (_currency != null &&
              ref.watch(exchangeRatesProvider).rateFor(_currency) == null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.ratesMissing(_currency!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(l.fieldIcon, style: theme.textTheme.labelLarge),
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
          Text(l.fieldColour, style: theme.textTheme.labelLarge),
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
                : Text(editing ? l.actionSave : l.createAccount),
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
