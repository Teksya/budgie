import 'package:budget/data/db/enums.dart';
import 'package:budget/features/accounts/accounts_page.dart';
import 'package:budget/features/categories/categories_page.dart';
import 'package:budget/features/charges/add_charge_page.dart';
import 'package:budget/features/charges/charges_page.dart';
import 'package:budget/features/charges/recurrences_page.dart';
import 'package:budget/features/dashboard/dashboard_page.dart';
import 'package:budget/features/debts/debts_page.dart';
import 'package:budget/features/history/history_page.dart';
import 'package:budget/features/settings/settings_page.dart';
import 'package:budget/features/stats/stats_page.dart';
import 'package:budget/features/transactions/add_transaction_page.dart';
import 'package:budget/features/transactions/transactions_page.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => _HomeShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (_, _) => const DashboardPage()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transactions',
              builder: (_, _) => const TransactionsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/budgets',
              builder: (_, _) => const ChargesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/stats',
              builder: (_, _) => const StatsPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/add',
      parentNavigatorKey: _rootKey,
      builder: (context, state) {
        final type = state.uri.queryParameters['type'] == 'income'
            ? TxnType.income
            : TxnType.expense;
        return AddTransactionPage(initialType: type);
      },
    ),
    GoRoute(
      path: '/charges/add',
      parentNavigatorKey: _rootKey,
      builder: (context, state) =>
          AddChargePage(income: state.uri.queryParameters['type'] == 'income'),
    ),
    GoRoute(
      path: '/categories',
      parentNavigatorKey: _rootKey,
      builder: (_, _) => const CategoriesPage(),
    ),
    GoRoute(
      path: '/accounts',
      parentNavigatorKey: _rootKey,
      builder: (_, _) => const AccountsPage(),
    ),
    GoRoute(
      path: '/recurrences',
      parentNavigatorKey: _rootKey,
      builder: (_, _) => const RecurrencesPage(),
    ),
    GoRoute(
      path: '/debts',
      parentNavigatorKey: _rootKey,
      builder: (_, _) => const DebtsPage(),
    ),
    GoRoute(
      path: '/history',
      parentNavigatorKey: _rootKey,
      builder: (_, _) => const HistoryPage(),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootKey,
      builder: (_, _) => const SettingsPage(),
    ),
  ],
);

class _HomeShell extends StatelessWidget {
  const _HomeShell({required this.shell});

  final StatefulNavigationShell shell;

  void _select(int i) =>
      shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final destinations = <(IconData, IconData, String)>[
      (Icons.home_outlined, Icons.home, l.navHome),
      (Icons.receipt_long_outlined, Icons.receipt_long, l.navTransactions),
      (Icons.pie_chart_outline, Icons.pie_chart, l.navBudgets),
      (Icons.insights_outlined, Icons.insights, l.navStats),
    ];
    // Above this width, use a side rail and a wider content column instead of
    // the bottom bar — the tablet / foldable / landscape layout.
    final wide = MediaQuery.sizeOf(context).width >= 720;

    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _select,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final (icon, selected, label) in destinations)
                  NavigationRailDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(selected),
                    label: Text(label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            // Cap the content width so lines don't stretch uncomfortably wide.
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: shell,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        // `initialLocation: true` when re-tapping the active tab pops that
        // branch back to its root, which is what users expect.
        onDestinationSelected: _select,
        destinations: [
          for (final (icon, selected, label) in destinations)
            NavigationDestination(
              icon: Icon(icon),
              selectedIcon: Icon(selected),
              label: label,
            ),
        ],
      ),
    );
  }
}
