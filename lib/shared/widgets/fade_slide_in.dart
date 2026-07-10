import 'dart:async';

import 'package:budget/app/theme/motion.dart';
import 'package:flutter/material.dart';

/// Fades and slides its child up on first build, with an optional stagger
/// [delay]. Used to make screens arrive with a bit of life instead of popping.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    required this.child,
    this.delay = Duration.zero,
    this.offset = 16,
    super.key,
  });

  final Widget child;
  final Duration delay;
  final double offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.emphasized,
  );

  @override
  void initState() {
    super.initState();
    unawaited(
      Future<void>.delayed(widget.delay, () {
        if (mounted) unawaited(_controller.forward());
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: AppMotion.enter,
    );
    return AnimatedBuilder(
      animation: curved,
      builder: (context, child) => Opacity(
        opacity: curved.value,
        child: Transform.translate(
          offset: Offset(0, widget.offset * (1 - curved.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}
