import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/data/repositories/account_repository.dart';
import 'package:budget/features/accounts/account_editor_page.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/icons.dart';
import 'package:budget/shared/labels.dart';
import 'package:budget/shared/widgets/amount_text.dart';
import 'package:budget/shared/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final accounts = ref.watch(accountsWithBalanceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.accounts)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openAccountEditor(context),
        icon: const Icon(Icons.add),
        label: Text(l.account),
      ),
      body: accounts.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: SkeletonList(rows: 4),
        ),
        error: (e, _) => Center(child: Text(l.errorWith('$e'))),
        data: (list) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl * 4,
          ),
          children: [
            for (final item in list) _AccountCard(item: item),
          ],
        ),
      ),
    );
  }
}

class _AccountCard extends ConsumerWidget {
  const _AccountCard({required this.item});

  final AccountWithBalance item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final a = item.account;
    final color = a.colorValue != null ? Color(a.colorValue!) : scheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: color.withValues(alpha: 0.16),
            foregroundColor: color,
            child: Icon(iconFor(a.iconKey)),
          ),
          title: Text(a.name, style: theme.textTheme.titleMedium),
          subtitle: Text(a.type.label(l)),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AmountText(
                item.balance,
                colorBySign: true,
                style: theme.textTheme.titleMedium,
              ),
              Text(
                a.currencyCode == null
                    ? l.balance
                    : '${ref.watch(exchangeRatesProvider).fromMain(item.balance, a.currencyCode).format()} ${a.currencyCode}',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
          onTap: () => openAccountEditor(context, existing: a),
        ),
      ),
    );
  }
}
