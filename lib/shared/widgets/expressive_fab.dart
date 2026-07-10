import 'package:budget/app/theme/motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// An extended FAB with an Expressive touch: it springs down slightly on press
/// and settles back with an overshoot when released. The stock FAB only ripples
/// — this adds the tactile, physical feel M3 Expressive is after.
class ExpressiveFab extends StatefulWidget {
  const ExpressiveFab({
    required this.onPressed,
    required this.icon,
    required this.label,
    this.heroTag,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final String label;
  final Object? heroTag;

  @override
  State<ExpressiveFab> createState() => _ExpressiveFabState();
}

class _ExpressiveFabState extends State<ExpressiveFab>
    with SingleTickerProviderStateMixin {
  // Bounds go past 1 so the release spring can overshoot and bounce back
  // instead of being clamped flat at rest.
  late final AnimationController _controller = AnimationController(
    vsync: this,
    lowerBound: 0.9,
    upperBound: 1.12,
    value: 1,
  );

  void _down() => _controller.animateTo(
    0.92,
    duration: AppMotion.quick,
    curve: Curves.easeOut,
  );

  void _up() => _controller.animateWith(
    SpringSimulation(AppMotion.expressiveSpring, _controller.value, 1, 0),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _down(),
      onPointerUp: (_) => _up(),
      onPointerCancel: (_) => _up(),
      child: ScaleTransition(
        scale: _controller,
        child: FloatingActionButton.extended(
          heroTag: widget.heroTag,
          onPressed: widget.onPressed,
          icon: widget.icon,
          label: Text(widget.label),
        ),
      ),
    );
  }
}
