import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

class FadeOutAnimator extends Animator {
  Animation<double> opacity;

  FadeOutAnimator({
    @required TickerProvider vsync,
  }) : assert(vsync != null) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 600),
    );

    opacity =
        ReverseTween(Tween(begin: 0.0, end: 1.0))
            .animate(controller);
  }

  Widget buildWidget(Widget child) {
    return AnimatedBuilder(
      animation: controller,
      child: child,

      builder: (context, child) {
        return FadeTransition(
          opacity: opacity,
          child: child,
        );
      },
    );
  }
}
