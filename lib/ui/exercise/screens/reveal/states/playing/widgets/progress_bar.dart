import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class ExerciseProgressBar extends StatefulWidget {
  /// Height of the progress-bar, in pixels.
  final double height;

  /// Whether the progress-bar should be visible.
  /// This widget supports animations on this property.
  final bool visible;

  /// Current exercising session - since it contains all the information required to render a progress-bar, it must be
  /// specified.
  final Exercise exercise;

  ExerciseProgressBar({
    @required this.height,
    @required this.visible,
    @required this.exercise,
  })
      : assert(height != null),
        assert(visible != null),
        assert(exercise != null);

  @override
  State<StatefulWidget> createState() => _ExerciseProgressBarState();

  List<Optional<MaterialColor>> getColorIntervals() {
    return exercise.getAnswers().map<Optional<MaterialColor>>((answer) {
      switch (answer.type) {
        case ExerciseAnswerType.correct:
          return Optional.of(Colors.green);

        case ExerciseAnswerType.invalid:
          return Optional.of(Colors.red);

        default:
          return const Optional.empty();
      }
    }).toList();
  }
}

class _ExerciseProgressBarState extends State<ExerciseProgressBar> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;

    return AnimatedBuilder(
      animation: animation,

      child: Column(
        children: [
          SizedBox(
            height: widget.height,

            child: ColorInterleavedProgressBar(
              backgroundColor: Colors.grey,
              intervals: widget.getColorIntervals(),
            ),
          ),
        ],
      ),

      builder: (context, child) {
        return Transform.translate(
          child: child,
          offset: Offset(0, height - widget.height * animation.value),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    animation =
        CurveTween(curve: Curves.linear)
            .animate(animationController);
  }

  @override
  void didUpdateWidget(ExerciseProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.visible && widget.visible) {
      animationController.forward(from: 0.0);
    }

    if (oldWidget.visible && !widget.visible) {
      animationController.reverse(from: 1.0);
    }
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }
}
