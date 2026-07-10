import 'package:budget/app/theme/shapes.dart';
import 'package:flutter/material.dart';

/// A shimmering placeholder shown while data loads, so screens fade in with a
/// sense of their shape instead of a bare spinner.
class Shimmer extends StatefulWidget {
  const Shimmer({required this.child, super.key});

  final Widget child;

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Color.alphaBlend(
      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.06),
      base,
    );
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [base, highlight, base],
            stops: [
              (t - 0.3).clamp(0.0, 1.0),
              t.clamp(0.0, 1.0),
              (t + 0.3).clamp(0.0, 1.0),
            ],
          ).createShader(bounds),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// A single rounded placeholder block.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.width = double.infinity,
    this.height = 16,
    this.radius = AppRadius.sm,
    super.key,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// A few list-row placeholders inside a card, for lists that are loading.
class SkeletonList extends StatelessWidget {
  const SkeletonList({this.rows = 3, super.key});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              for (var i = 0; i < rows; i++) ...[
                if (i > 0) const SizedBox(height: AppSpacing.lg),
                const Row(
                  children: [
                    SkeletonBox(
                      width: 40,
                      height: 40,
                      radius: AppRadius.full,
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonBox(width: 140, height: 14),
                          SizedBox(height: 8),
                          SkeletonBox(width: 80, height: 12),
                        ],
                      ),
                    ),
                    SkeletonBox(width: 56, height: 16),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
