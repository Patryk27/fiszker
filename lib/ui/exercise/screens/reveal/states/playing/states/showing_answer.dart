import 'dart:math';

import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class ShowingAnswer extends PlayingBlocState {
  @override
  Widget buildActionsWidget() => _Actions();

  @override
  Widget buildBodyWidget() => _Body();
}

class _Actions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // "Reject answer" button
        RaisedButton(
          color: Colors.red,
          shape: CircleBorder(),
          elevation: 25,

          child: const Padding(
            padding: const EdgeInsets.all(30),
            child: const Icon(Icons.clear),
          ),

          onPressed: () {
            PlayingBloc.of(context).add(
              Answer(
                isCorrect: false,
              ),
            );
          },
        ),

        // Separator
        const SizedBox(width: 20),

        // "Accept answer" button
        RaisedButton(
          color: Colors.green,
          shape: CircleBorder(),
          elevation: 25,

          child: const Padding(
            padding: const EdgeInsets.all(30),
            child: const Icon(Icons.check),
          ),

          onPressed: () {
            PlayingBloc.of(context).add(
              Answer(
                isCorrect: true,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Body extends StatefulWidget {
  @override
  State<_Body> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_Body> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = PlayingBloc.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform(
          alignment: FractionalOffset.center,

          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.0)
            ..rotateY(
                (animation.value >= 0.5)
                    ? (pi - animation.value * pi)
                    : (-animation.value * pi)
            ),

          child: CardSide(
            size: Size(300, 300),
            text: animation.value >= 0.5
                ? bloc.exercise.currentCard.back
                : bloc.exercise.currentCard.front,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    animation =
        CurveTween(curve: Curves.easeInOutCirc)
            .animate(animationController);

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }
}
