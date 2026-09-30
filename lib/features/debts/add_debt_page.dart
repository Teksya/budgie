import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/db/enums.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/labels.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDebtPage extends ConsumerStatefulWidget {
  const AddDebtPage({super.key});

  @override
  ConsumerState<AddDebtPage> createState() => _AddDebtPageState();
}

class _AddDebtPageState extends ConsumerState<AddDebtPage> {
  final _name = TextEditingController();
  final _principal = TextEditingController();
  final _installment = TextEditingController();
  final _count = TextEditingController();
  DebtKind _kind = DebtKind.credit;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _principal.dispose();
    _installment.dispose();
    _count.dispose();
    super.dispose();
  }

  Money? _money(TextEditingController c) {
    final v = double.tryParse(c.text.trim().replaceAll(',', '.'));
    if (v == null || v <= 0) return null;
    return Money.fromEuros(v);
  }

  bool get _valid => _name.text.trim().isNotEmpty && _money(_principal) != null;

  Future<void> _save() async {
    if (!_valid) return;
    setState(() => _saving = true);
    final principal = _money(_principal)!;
    final count = int.tryParse(_count.text.trim());

    await ref.read(debtRepositoryProvider).add(
      DebtsCompanion.insert(
        name: _name.text.trim(),
        kind: _kind,
        principalCents: principal.cents,
        remainingCents: principal.cents,
        installmentCents: Value(_money(_installment)?.cents ?? 0),
        installmentsTotal: Value(count),
        startDate: DateTime.now(),
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final lent = _kind == DebtKind.debtLent;

    return Scaffold(
      appBar: AppBar(title: Text(l.newDebtTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl * 2,
        ),
        children: [
          Text(l.fieldType, style: theme.textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final k in DebtKind.values)
                ChoiceChip(
                  label: Text(k.label(l)),
                  selected: _kind == k,
                  onSelected: (_) => setState(() => _kind = k),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _name,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              labelText: l.fieldName,
              hintText: lent ? l.debtNameHintLent : l.debtNameHintOwed,
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _principal,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
            ],
            decoration: InputDecoration(
              labelText: lent ? l.debtAmountLent : l.debtAmountOwed,
              suffixText: AppCurrency.instance.symbol,
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (!lent) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _installment,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l.debtMonthlyPayment,
                      suffixText: AppCurrency.instance.symbol,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _count,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: l.debtInstalmentsCount,
                    ),
                  ),
                ),
              ],
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
                : Text(l.actionSave),
          ),
        ],
      ),
    );
  }
}
