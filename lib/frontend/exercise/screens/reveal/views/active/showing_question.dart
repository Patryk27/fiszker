import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class ShowingQuestion extends StatelessWidget {
  final CardModel card;
  final void Function() onRevealAnswerPressed;

  ShowingQuestion({
    @required this.card,
    @required this.onRevealAnswerPressed,
  })
      : assert(card != null),
        assert(onRevealAnswerPressed != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: const SizedBox(),
        ),

        Expanded(
          flex: 2,
          child: Center(
            child: CardSide(
              size: Size(300, 300),
              text: card.front,
            ),
          ),
        ),

        Expanded(
          flex: 2,
          child: Center(
            child: RaisedButton(
              color: Colors.lightBlue,
              onPressed: onRevealAnswerPressed,
              child: const Padding(
                padding: const EdgeInsets.all(15),
                child: const Text('POKAŻ ODPOWIEDŹ'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
