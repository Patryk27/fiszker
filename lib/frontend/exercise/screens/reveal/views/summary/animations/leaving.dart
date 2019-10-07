import 'package:flutter/material.dart';

class LeavingAnimation {
  AnimationController _animationController;
  Animation<double> _fadeAnimation;
  Animation<double> _scaleAnimation;

  LeavingAnimation({
    @required TickerProvider vsync,
  }) : assert(vsync != null) {
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 1500),
    );

    // Initialize animation
    _fadeAnimation =
        Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOutQuad))
            .animate(_animationController);

    _scaleAnimation =
        Tween(begin: 1.0, end: 2.0)
            .chain(CurveTween(curve: Curves.easeInOutQuad))
            .animate(_animationController);
  }

  Animation<double> get animation {
    return _fadeAnimation;
  }

  Future<void> start() async {
    return await _animationController.forward();
  }

  void dispose() {
    _animationController.dispose();
  }
}

class LeavingAnimator extends StatelessWidget {
  final LeavingAnimation animation;
  final Widget child;

  LeavingAnimator({
    @required this.animation,
    @required this.child,
  })
      : assert(animation != null),
        assert(child != null);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation.animation,
      child: child,

      builder: (context, child) {
        return FadeTransition(
          opacity: animation._fadeAnimation,
          child: ScaleTransition(
            scale: animation._scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
