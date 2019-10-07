import 'dart:math';

import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class ShowingAnswer extends StatelessWidget {
  final CardModel card;
  final double animationProgress;
  final void Function() onAcceptAnswerPressed;
  final void Function() onRejectAnswerPressed;

  ShowingAnswer({
    @required this.card,
    @required this.animationProgress,
    @required this.onAcceptAnswerPressed,
    @required this.onRejectAnswerPressed,
  })
      : assert(card != null),
        assert(animationProgress != null),
        assert(onAcceptAnswerPressed != null),
        assert(onRejectAnswerPressed != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: const SizedBox(),
        ),

        Expanded(
          flex: 2,
          child: Center(
            child: Transform(
              alignment: FractionalOffset.center,

              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(0.0)
                ..rotateY((animationProgress >= 0.5) ? (pi - animationProgress * pi) : (-animationProgress * pi)),

              child: CardSide(
                size: Size(300, 300),
                text: animationProgress >= 0.5 ? card.back : card.front,
              ),
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // "Reject answer" button
              RaisedButton(
                color: Colors.red,
                onPressed: onRejectAnswerPressed,
                shape: CircleBorder(),
                elevation: 25,

                child: const Padding(
                  padding: const EdgeInsets.all(30),
                  child: const Icon(Icons.clear),
                ),
              ),

              // Separator
              const SizedBox(width: 20),

              // "Accept answer" button
              RaisedButton(
                color: Colors.green,
                onPressed: onAcceptAnswerPressed,
                shape: CircleBorder(),
                elevation: 25,

                child: const Padding(
                  padding: const EdgeInsets.all(30),
                  child: const Icon(Icons.check),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
