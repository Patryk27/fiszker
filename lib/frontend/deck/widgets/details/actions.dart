import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

class DeckDetailsActions extends StatelessWidget {
  final DeckViewModel deck;
  final void Function() onDeletePressed;
  final void Function() onExercisePressed;
  final void Function() onEditPressed;

  DeckDetailsActions({
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
    return ButtonTheme.bar(
      child: ButtonBar(
        children: [
          FlatButton(
            child: const Text('USUŃ'),
            onPressed: onDeletePressed,
          ),

          FlatButton(
            child: const Text('EDYTUJ'),
            onPressed: onEditPressed,
          ),

          FlatButton(
            child: const Text('ĆWICZ'),
            onPressed: onExercisePressed,
          ),
        ],
      ),
    );
  }
}
