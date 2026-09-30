import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/core/date_x.dart';
import 'package:budget/core/money.dart';
import 'package:budget/data/db/database.dart';
import 'package:budget/data/repositories/history_repository.dart';
import 'package:budget/data/repositories/stats_repository.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:budget/shared/widgets/budget_ring.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The month, closed and told as a story: what came in, where it went, what
/// is left. Shown when a period rolls over, and reachable from the history.
///
/// Reuses the dashboard's ring on purpose — a recap that looks like a report
/// gets read once; one that looks like the screen you check every day gets
/// read every month.
class MonthRecapPage extends ConsumerWidget {
  const MonthRecapPage({required this.period, super.key});

  final Period period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = L.of(context);
    final range = PeriodRange(period.startDate, period.endDate);
    final summary = ref.watch(periodRecapProvider(period.id));

    return Scaffold(
      appBar: AppBar(title: Text(l.recapTitle), leading: const BackButton()),
      body: summary.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorWith('$e'))),
        data: (data) => ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          children: [
            _Hero(range: range, summary: data.summary, slices: data.slices),
            const SizedBox(height: AppSpacing.lg),
            _Verdict(summary: data.summary),
            const SizedBox(height: AppSpacing.lg),
            if (data.slices.isNotEmpty) _TopCategories(slices: data.slices),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.range,
    required this.summary,
    required this.slices,
  });

  final PeriodRange range;
  final PeriodSummary summary;
  final List<CategorySlice> slices;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final saved = !summary.net.isNegative;

    return Column(
      children: [
        Text(range.label, style: theme.textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        BudgetRing(
          size: 220,
          thickness: 28,
          semanticsLabel: l.recapSemantics(
            summary.incomeReceived.formatRounded(),
            summary.expenses.formatRounded(),
          ),
          segments: [
            for (final s in slices.take(5))
              RingSegment(
                label: s.categoryName,
                color: Color(s.colorValue),
                amount: s.total.euros,
              ),
          ],
          center: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                saved ? l.recapSaved : l.recapOverspent,
                style: theme.textTheme.labelMedium,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  summary.net.abs.formatRounded(),
                  maxLines: 1,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: saved ? scheme.healthy : scheme.error,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Verdict extends StatelessWidget {
  const _Verdict({required this.summary});

  final PeriodSummary summary;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _Line(label: l.incomeReceived, amount: summary.incomeReceived),
            const Divider(height: AppSpacing.lg),
            _Line(label: l.expenses, amount: summary.expenses),
            const Divider(height: AppSpacing.lg),
            _Line(
              label: l.closingBalance,
              amount: summary.closingBalance,
              strong: true,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              summary.net.isNegative
                  ? l.recapAdviceOver
                  : l.recapAdviceSaved(summary.net.formatRounded()),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.amount, this.strong = false});

  final String label;
  final Money amount;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = strong
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyLarge;
    return MergeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyLarge),
          Text(amount.format(), style: style),
        ],
      ),
    );
  }
}

class _TopCategories extends StatelessWidget {
  const _TopCategories({required this.slices});

  final List<CategorySlice> slices;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final total = slices.fold(Money.zero, (a, s) => a + s.total);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.recapWhereItWent, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            for (final s in slices.take(5))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: MergeSemantics(
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color(s.colorValue),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(s.categoryName)),
                      Text(
                        total.isPositive
                            ? l.recapShare(
                                s.total.format(),
                                (s.total.cents * 100 / total.cents).round(),
                              )
                            : s.total.format(),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
