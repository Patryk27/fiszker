import 'package:flutter/material.dart';

class EnteringAnimation {
  AnimationController _animationController;
  Animation<double> _opacityAnimation;

  EnteringAnimation({
    @required TickerProvider vsync,
  }) : assert(vsync != null) {
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1000),
    );

    // Initialize animation
    _opacityAnimation =
        CurveTween(curve: Curves.easeInOutCirc)
            .animate(_animationController);
  }

  void start() {
    _animationController.forward();
  }

  void dispose() {
    _animationController.dispose();
  }

  void onCompleted(void Function() fn) {
    _opacityAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        fn();
      }
    });
  }
}

class EnteringAnimator extends StatelessWidget {
  final EnteringAnimation animation;
  final Widget child;

  EnteringAnimator({
    @required this.animation,
    @required this.child,
  })
      : assert(animation != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation._opacityAnimation,
      child: child,

      builder: (context, child) {
        return FadeTransition(
          opacity: animation._opacityAnimation,
          child: child,
        );
      },
    );
  }
}
