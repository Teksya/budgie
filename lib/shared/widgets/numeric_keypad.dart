import 'dart:async';

import 'package:budget/app/theme/shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A large, one-handed amount keypad. Edits a `,`-decimal string (e.g. `12,50`)
/// and enforces at most two decimals and a single separator, so the value is
/// always a valid amount.
class NumericKeypad extends StatelessWidget {
  const NumericKeypad({required this.value, required this.onChanged, super.key});

  final String value;
  final ValueChanged<String> onChanged;

  void _tapDigit(String d) {
    final commaAt = value.indexOf(',');
    if (commaAt >= 0 && value.length - commaAt > 2) return; // 2 decimals max
    if (value == '0') {
      onChanged(d); // replace a lone leading zero
      return;
    }
    onChanged('$value$d');
  }

  void _tapDecimal() {
    if (value.contains(',')) return;
    onChanged(value.isEmpty ? '0,' : '$value,');
  }

  void _backspace() {
    if (value.isEmpty) return;
    onChanged(value.substring(0, value.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    final keys = <String>['1', '2', '3', '4', '5', '6', '7', '8', '9'];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: 1.9,
      children: [
        for (final k in keys) _Key(label: k, onTap: () => _tapDigit(k)),
        _Key(label: ',', onTap: _tapDecimal),
        _Key(label: '0', onTap: () => _tapDigit('0')),
        _Key(
          icon: Icons.backspace_outlined,
          onTap: _backspace,
          onLongPress: () => onChanged(''),
        ),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.onTap, this.label, this.icon, this.onLongPress});

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () {
          unawaited(HapticFeedback.selectionClick());
          onTap();
        },
        onLongPress: onLongPress,
        child: Center(
          child: icon != null
              ? Icon(icon, color: theme.colorScheme.onSurface)
              : Text(
                  label!,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
