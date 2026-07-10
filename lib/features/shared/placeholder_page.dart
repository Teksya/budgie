import 'package:budget/app/theme/shapes.dart';
import 'package:flutter/material.dart';

/// Temporary scaffold for tabs that arrive in a later phase. Deleted as each
/// feature lands.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.title,
    required this.icon,
    required this.phase,
    super.key,
  });

  final String title;
  final IconData icon;
  final String phase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: ShapeDecoration(
                  shape: AppShapes.hero,
                  color: scheme.secondaryContainer,
                ),
                child: Icon(icon, size: 48, color: scheme.onSecondaryContainer),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                phase,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
