import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

const _goalIcons = [
  'target',
  'plane',
  'home',
  'car',
  'gift',
  'piggy',
  'health',
];

class AddGoalPage extends ConsumerStatefulWidget {
  const AddGoalPage({super.key});

  @override
  ConsumerState<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends ConsumerState<AddGoalPage> {
  final _name = TextEditingController();
  final _target = TextEditingController();
  final _monthly = TextEditingController();
  String _iconKey = 'target';
  DateTime? _targetDate;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _target.dispose();
    _monthly.dispose();
    super.dispose();
  }

  Money? _parse(TextEditingController c) {
    final v = double.tryParse(c.text.trim().replaceAll(',', '.'));
    if (v == null || v <= 0) return null;
    return Money.fromEuros(v);
  }

  bool get _valid => _name.text.trim().isNotEmpty && _parse(_target) != null;

  Future<void> _save() async {
    if (!_valid) return;
    setState(() => _saving = true);
    await ref
        .read(goalRepositoryProvider)
        .add(
          SavingsGoalsCompanion.insert(
            name: _name.text.trim(),
            targetCents: _parse(_target)!.cents,
            targetDate: Value(_targetDate),
            monthlyPlannedCents: Value(_parse(_monthly)?.cents ?? 0),
            iconKey: Value(_iconKey),
          ),
        );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.newGoal)),
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
              hintText: l.goalNameHint,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _target,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            decoration: InputDecoration(
              labelText: l.goalTarget,
              suffixText: AppCurrency.instance.symbol,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _monthly,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            decoration: InputDecoration(
              labelText: l.goalMonthly,
              helperText: l.goalMonthlyHelp,
              suffixText: AppCurrency.instance.symbol,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _DateField(
            date: _targetDate,
            onChanged: (d) => setState(() => _targetDate = d),
            onClear: () => setState(() => _targetDate = null),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(l.fieldIcon, style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final key in _goalIcons)
                GestureDetector(
                  onTap: () => setState(() => _iconKey = key),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _iconKey == key
                          ? theme.colorScheme.primaryContainer
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(
                      iconFor(key),
                      color: _iconKey == key
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: (_valid && !_saving) ? _save : null,
            child: _saving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l.createGoal),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.date,
    required this.onChanged,
    required this.onClear,
  });

  final DateTime? date;
  final ValueChanged<DateTime> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.md),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: L.of(context).goalTargetDate,
          suffixIcon: date == null
              ? const Icon(Icons.calendar_today, size: 18)
              : IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  tooltip: L.of(context).clearDate,
                  onPressed: onClear,
                ),
        ),
        child: Text(
          date == null
              ? 'Aucune'
              : DateFormat('d MMMM y', 'fr_FR').format(date!),
        ),
      ),
    );
  }
}
