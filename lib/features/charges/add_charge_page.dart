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

/// Opens the recurrence editor for an existing template.
Future<void> openRecurrenceEditor(BuildContext context, Recurrence r) =>
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddChargePage(existing: r),
      ),
    );

/// Form for a recurring money movement: a fixed charge / subscription
/// (loyer, électricité…) or a recurring income (salaire, allocation…).
class AddChargePage extends ConsumerStatefulWidget {
  const AddChargePage({this.income = false, this.existing, super.key});

  /// When true the form creates a recurring income (salary) instead of a
  /// charge to pay.
  final bool income;

  /// When set, the form edits this template instead of creating a new one.
  final Recurrence? existing;

  @override
  ConsumerState<AddChargePage> createState() => _AddChargePageState();
}

class _AddChargePageState extends ConsumerState<AddChargePage> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late final _amount = TextEditingController(
    text: widget.existing == null
        ? ''
        : (widget.existing!.estimatedAmountCents / 100).toStringAsFixed(2),
  );
  late int? _categoryId = widget.existing?.categoryId;
  late int? _accountId = widget.existing?.accountId;
  late Frequency _frequency = widget.existing?.frequency ?? Frequency.monthly;
  late RecurrenceNature _nature =
      widget.existing?.nature ?? RecurrenceNature.fixedCharge;
  late int _dueDay = widget.existing?.dueDayOfMonth ?? 5;
  late bool _isVariable = widget.existing?.isVariable ?? false;
  bool _saving = false;

  bool get _income =>
      widget.existing?.type == TxnType.income || widget.income;
  bool get _editing => widget.existing != null;

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  Money? get _parsedAmount {
    final raw = _amount.text.trim().replaceAll(',', '.');
    final value = double.tryParse(raw);
    if (value == null || value < 0) return null;
    return Money.fromEuros(value);
  }

  bool get _valid => _name.text.trim().isNotEmpty && _parsedAmount != null;

  Future<void> _save() async {
    if (!_valid || _accountId == null) return;
    setState(() => _saving = true);
    final repo = ref.read(recurrenceRepositoryProvider);

    if (_editing) {
      await repo.update(
        widget.existing!.copyWith(
          name: _name.text.trim(),
          nature: _income ? RecurrenceNature.salary : _nature,
          categoryId: Value(_categoryId),
          accountId: _accountId,
          estimatedAmountCents: _parsedAmount!.cents,
          isVariable: !_income && _isVariable,
          frequency: _frequency,
          dueDayOfMonth: _dueDay,
        ),
      );
    } else {
      await repo.add(
        RecurrencesCompanion.insert(
          name: _name.text.trim(),
          type: _income ? TxnType.income : TxnType.expense,
          nature: _income ? RecurrenceNature.salary : _nature,
          categoryId: Value(_categoryId),
          accountId: _accountId!,
          estimatedAmountCents: _parsedAmount!.cents,
          isVariable: Value(!_income && _isVariable),
          frequency: _frequency,
          dueDayOfMonth: _dueDay,
          startDate: DateTime.now(),
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _editing
              ? 'Modifié'
              : (_income ? 'Revenu récurrent ajouté' : 'Charge ajoutée'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final kind = _income ? CategoryKind.income : CategoryKind.expense;
    final categories = (ref.watch(categoriesProvider).value ?? const [])
        .where((c) => c.kind == kind && (_income || c.parentId != null))
        .toList();
    final accounts = ref.watch(accountsProvider).value ?? const [];

    if (_accountId == null && accounts.isNotEmpty) {
      _accountId = accounts.first.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editing
              ? 'Modifier'
              : (_income ? 'Revenu récurrent' : 'Nouvelle charge fixe'),
        ),
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
              labelText: 'Nom',
              hintText: _income
                  ? 'Salaire, Allocation, Pension…'
                  : 'Loyer, Électricité, Internet…',
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            decoration: InputDecoration(
              labelText: _income
                  ? 'Montant net'
                  : (_isVariable ? 'Montant estimé' : 'Montant'),
              suffixText: '€',
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (!_income) ...[
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Montant variable'),
              subtitle: Text(
                "Comme l'électricité ou l'eau : tu corriges le montant réel "
                'à réception de la facture.',
                style: theme.textTheme.bodySmall,
              ),
              value: _isVariable,
              onChanged: (v) => setState(() => _isVariable = v),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Type', style: theme.textTheme.labelLarge),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                for (final n in const [
                  RecurrenceNature.fixedCharge,
                  RecurrenceNature.subscription,
                ])
                  ChoiceChip(
                    label: Text(n.label),
                    selected: _nature == n,
                    onSelected: (_) => setState(() => _nature = n),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.md),
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
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<Frequency>(
            initialValue: _frequency,
            decoration: const InputDecoration(labelText: 'Périodicité'),
            items: [
              for (final f in Frequency.values)
                DropdownMenuItem(value: f, child: Text(f.label)),
            ],
            onChanged: (v) => setState(() => _frequency = v ?? _frequency),
          ),
          const SizedBox(height: AppSpacing.md),
          _DueDayField(
            day: _dueDay,
            label: _income ? 'Jour de versement' : "Jour d'échéance",
            onChanged: (d) => setState(() => _dueDay = d),
          ),
          if (accounts.length > 1) ...[
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              initialValue: _accountId,
              decoration: const InputDecoration(labelText: 'Compte'),
              items: [
                for (final a in accounts)
                  DropdownMenuItem(value: a.id, child: Text(a.name)),
              ],
              onChanged: (v) => setState(() => _accountId = v),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: (_valid && !_saving) ? _save : null,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _income
                        ? 'Enregistrer le revenu'
                        : 'Enregistrer la charge',
                  ),
          ),
        ],
      ),
    );
  }
}

class _DueDayField extends StatelessWidget {
  const _DueDayField({
    required this.day,
    required this.label,
    required this.onChanged,
  });

  final int day;
  final String label;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label : le $day',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        IconButton.filledTonal(
          onPressed: day > 1 ? () => onChanged(day - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        const SizedBox(width: AppSpacing.xs),
        IconButton.filledTonal(
          onPressed: day < 31 ? () => onChanged(day + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
