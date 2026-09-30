import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/app_currency.dart';
import 'package:budget/core/exchange_rates.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Where the user tells the app what a foreign currency is worth.
///
/// There is no "refresh" button and there never will be — the app has no
/// network. The screen says so plainly rather than leaving the user to wonder
/// why the rate never updates.
class ExchangeRatesPage extends ConsumerWidget {
  const ExchangeRatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final rates = ref.watch(exchangeRatesProvider);
    final main = AppCurrency.instance.code;

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsRates), leading: const BackButton()),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l.ratesAdd),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl * 4,
        ),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                l.ratesIntro,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          if (rates.isEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                l.ratesNone,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            Card(
              child: Column(
                children: [
                  for (final entry in rates.all) ...[
                    if (entry.key != rates.all.first.key)
                      const Divider(height: 1),
                    ListTile(
                      title: Text(l.ratesOneUnitEquals(entry.key)),
                      subtitle: Text('${entry.value} $main'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: l.actionDelete,
                        onPressed: () => ref
                            .read(settingsRepositoryProvider)
                            .put(ExchangeRates.keyFor(entry.key), ''),
                      ),
                      onTap: () => _edit(context, ref, code: entry.key),
                    ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref, {
    String? code,
  }) async {
    final l = L.of(context);
    final repo = ref.read(settingsRepositoryProvider);
    final existing = ref.read(exchangeRatesProvider).rateFor(code);
    final codeField = TextEditingController(text: code ?? '');
    final rateField = TextEditingController(text: existing?.toString() ?? '');

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l.settingsRates),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeField,
              enabled: code == null,
              autofocus: code == null,
              textCapitalization: TextCapitalization.characters,
              maxLength: 3,
              decoration: InputDecoration(labelText: l.settingsCurrency),
            ),
            TextField(
              controller: rateField,
              autofocus: code != null,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
              ],
              decoration: InputDecoration(
                labelText: l.ratesOneUnitEquals(
                  codeField.text.isEmpty ? '…' : codeField.text.toUpperCase(),
                ),
                suffixText: AppCurrency.instance.symbol,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(l.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(l.actionSave),
          ),
        ],
      ),
    );

    if (saved ?? false) {
      final iso = codeField.text.trim().toUpperCase();
      final value = rateField.text.trim();
      if (iso.length == 3 && value.isNotEmpty) {
        await repo.put(ExchangeRates.keyFor(iso), value);
      }
    }
    codeField.dispose();
    rateField.dispose();
  }
}
