import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

class ScaleOutAnimator extends Animator {
  Animation<double> opacity;
  Animation<double> scale;

  ScaleOutAnimator({
    @required TickerProvider vsync,
  }) : assert(vsync != null) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );

    opacity =
        Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOutQuad))
            .animate(controller);

    // @todo the scaling animation seem to cause FPS issues on slower phones - investigate
    scale =
        Tween(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeInOutQuad))
            .animate(controller);
  }

  Widget buildWidget(Widget child) {
    return AnimatedBuilder(
      animation: controller,
      child: child,

      builder: (context, child) {
        return FadeTransition(
          opacity: opacity,

          child: ScaleTransition(
            scale: scale,
            child: child,
          ),
        );
      },
    );
  }
}

