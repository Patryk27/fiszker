import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../../../misc.dart';

class ExerciseProgressBar extends StatefulWidget {
  final double height;
  final bool visible;
  final Answers answers;

  ExerciseProgressBar({
    @required this.height,
    @required this.visible,
    @required this.answers,
  })
      : assert(height != null),
        assert(visible != null),
        assert(answers != null);

  @override
  State<StatefulWidget> createState() {
    return _ExerciseProgressBarState();
  }

  List<Optional<MaterialColor>> _getIntervals() {
    return answers.list().map<Optional<MaterialColor>>((answer) {
      switch (answer) {
        case Answer.correct:
          return Optional.of(Colors.green);

        case Answer.invalid:
          return Optional.of(Colors.red);

        default:
          return Optional.empty();
      }
    }).toList();
  }
}

class _ExerciseProgressBarState extends State<ExerciseProgressBar> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;

    return AnimatedBuilder(
      animation: _animation,

      child: Column(
        children: [
          SizedBox(
            height: widget.height,
            child: ColorInterleavedProgressBar(
              backgroundColor: Colors.grey,
              intervals: widget._getIntervals(),
            ),
          ),
        ],
      ),

      builder: (context, child) {
        return Transform.translate(
          child: child,
          offset: Offset(0, height - widget.height * _animation.value),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    // Initialize controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Initialize animation
    _animation =
        CurveTween(curve: Curves.linear)
            .animate(_animationController);
  }

  @override
  void didUpdateWidget(ExerciseProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.visible && widget.visible) {
      _animationController.forward(from: 0.0);
    }

    if (oldWidget.visible && !widget.visible) {
      _animationController.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }
}
