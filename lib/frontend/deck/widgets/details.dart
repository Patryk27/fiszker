import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'details/actions.dart';
import 'details/body.dart';

class DeckDetails extends StatelessWidget {
  final DeckViewModel deck;
  final void Function() onDeletePressed;
  final void Function() onExercisePressed;
  final void Function() onEditPressed;

  DeckDetails({
    @required this.deck,
    @required this.onDeletePressed,
    @required this.onExercisePressed,
    @required this.onEditPressed,
  })
      : assert(deck != null),
        assert(onDeletePressed != null),
        assert(onExercisePressed != null),
        assert(onEditPressed != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        DeckDetailsBody(
          deck: deck,
        ),

        DeckDetailsActions(
          deck: deck,
          onDeletePressed: onDeletePressed,
          onExercisePressed: onExercisePressed,
          onEditPressed: onEditPressed,
        ),
      ],
    );
  }
}
