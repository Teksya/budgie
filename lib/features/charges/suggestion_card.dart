import 'dart:async';

import 'package:budget/app/providers.dart';
import 'package:budget/app/theme/shapes.dart';
import 'package:budget/data/repositories/suggestion_repository.dart';
import 'package:budget/domain/services/suggestion_engine.dart';
import 'package:budget/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A single nudge drawn from the spending history: a repeat worth turning into
/// a subscription, or a category worth capping.
///
/// One at a time, on purpose. A list of eight things the app thinks you should
/// do is a chore; one card with two buttons is an offer.
class SuggestionCard extends ConsumerWidget {
  const SuggestionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestions = ref.watch(suggestionsProvider).value;
    if (suggestions == null || suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Recurrences first: turning a repeat into a charge changes the forecast,
    // while an envelope only changes the reporting.
    final recurrence = suggestions.recurrences.firstOrNull;
    return recurrence != null
        ? _Card(
            icon: Icons.event_repeat_outlined,
            title: L.of(context).suggestRecurrenceTitle(recurrence.label),
            body: L.of(context).suggestRecurrenceBody(
              recurrence.occurrences,
              recurrence.amount.format(),
              recurrence.dayOfMonth,
            ),
            accept: L.of(context).suggestMakeItRecurring,
            onAccept: () => _acceptRecurrence(ref, recurrence),
            onDismiss: () => _dismiss(
              ref,
              SuggestionRepository.recurrenceKey(recurrence),
            ),
          )
        : _envelopeCard(context, ref, suggestions.envelopes.first);
  }

  Widget _envelopeCard(
    BuildContext context,
    WidgetRef ref,
    EnvelopeSuggestion suggestion,
  ) {
    final categories = ref.watch(categoriesProvider).value ?? const [];
    final name = categories
        .where((c) => c.id == suggestion.categoryId)
        .map((c) => c.name)
        .firstOrNull;
    // The category was deleted between the analysis and this frame.
    if (name == null) return const SizedBox.shrink();

    return _Card(
      icon: Icons.pie_chart_outline,
      title: L.of(context).suggestEnvelopeTitle(name),
      body: L.of(context).suggestEnvelopeBody(
        suggestion.months,
        suggestion.average.format(),
        suggestion.suggestedLimit.format(),
      ),
      accept: L.of(context).suggestSetTheCap,
      onAccept: () => _acceptEnvelope(ref, suggestion),
      onDismiss: () =>
          _dismiss(ref, SuggestionRepository.envelopeKey(suggestion)),
    );
  }

  Future<void> _acceptRecurrence(
    WidgetRef ref,
    RecurrenceSuggestion suggestion,
  ) async {
    final accountId = await ref.read(accountRepositoryProvider).defaultId();
    if (accountId == null) return;
    await ref
        .read(suggestionRepositoryProvider)
        .acceptRecurrence(suggestion, accountId: accountId);
    ref.invalidate(suggestionsProvider);
  }

  Future<void> _acceptEnvelope(
    WidgetRef ref,
    EnvelopeSuggestion suggestion,
  ) async {
    final period = await ref.read(openPeriodProvider.future);
    await ref
        .read(suggestionRepositoryProvider)
        .acceptEnvelope(suggestion, periodId: period.id);
    ref.invalidate(suggestionsProvider);
  }

  Future<void> _dismiss(WidgetRef ref, String key) async {
    await ref.read(suggestionRepositoryProvider).dismiss(key);
    ref.invalidate(suggestionsProvider);
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.icon,
    required this.title,
    required this.body,
    required this.accept,
    required this.onAccept,
    required this.onDismiss,
  });

  final IconData icon;
  final String title;
  final String body;
  final String accept;
  final Future<void> Function() onAccept;
  final Future<void> Function() onDismiss;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Card(
        color: scheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: scheme.onTertiaryContainer),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onTertiaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                body,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onTertiaryContainer,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => unawaited(onDismiss()),
                    child: Text(l.suggestNoThanks),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  FilledButton(
                    onPressed: () => unawaited(onAccept()),
                    child: Text(accept),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
