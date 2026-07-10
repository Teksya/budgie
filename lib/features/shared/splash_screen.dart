import 'package:budget/app/theme/shapes.dart';
import 'package:flutter/material.dart';

/// Brief branded screen shown while the first database read is in flight,
/// with a gently pulsing logo — nicer than a blank frame or a bare spinner.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          ),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: ShapeDecoration(
              shape: AppShapes.hero,
              color: scheme.primaryContainer,
            ),
            child: Icon(
              Icons.savings_outlined,
              size: 64,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
