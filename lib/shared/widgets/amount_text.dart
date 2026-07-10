import 'package:budget/app/theme/app_theme.dart';
import 'package:budget/core/money.dart';
import 'package:budget/domain/services/budget_engine.dart';
import 'package:flutter/material.dart';

/// A money amount rendered with tabular figures and, optionally, a sign colour
/// (green for income, default for expense).
class AmountText extends StatelessWidget {
  const AmountText(
    this.amount, {
    this.style,
    this.signed = false,
    this.colorBySign = false,
    super.key,
  });

  final Money amount;
  final TextStyle? style;

  /// Show a leading + / − sign.
  final bool signed;

  /// Colour positive amounts green, negative red.
  final bool colorBySign;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Color? color;
    if (colorBySign) {
      color = amount.isNegative ? scheme.danger : scheme.healthy;
    }
    return Text(
      signed ? amount.formatSigned() : amount.format(),
      style: (style ?? const TextStyle()).copyWith(color: color),
    );
  }
}

extension BudgetHealthColors on BudgetHealth {
  Color color(ColorScheme scheme) => switch (this) {
    BudgetHealth.healthy => scheme.healthy,
    BudgetHealth.caution => scheme.caution,
    BudgetHealth.danger => scheme.danger,
  };

  Color container(ColorScheme scheme) => switch (this) {
    BudgetHealth.healthy => scheme.healthyContainer,
    BudgetHealth.caution => scheme.cautionContainer,
    BudgetHealth.danger => scheme.dangerContainer,
  };

  Color onContainer(ColorScheme scheme) => switch (this) {
    BudgetHealth.healthy => scheme.onHealthyContainer,
    BudgetHealth.caution =>
      scheme.brightness == Brightness.light
          ? const Color(0xFF2A1A00)
          : const Color(0xFFFFDFB0),
    BudgetHealth.danger => scheme.onErrorContainer,
  };
}
