import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'details/detail.dart';

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
        assert(onExercisePressed != null),
        assert(onEditPressed != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(deck.deck.name),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          DetailsDetail(
            title: 'Liczba fiszek:',
            value: deck.cards.length.toString(),
          ),

          const SizedBox(height: 15),

          DetailsDetail(
            title: 'Utworzony:',
            value: timeago.format(deck.deck.createdAt),
          ),

          const SizedBox(height: 15),

          DetailsDetail(
            title: 'Ostatnio ćwiczony:',
            value: deck.deck.exercisedAt.map(timeago.format).orElse('-'),
          ),
        ],
      ),

      actions: [
        FlatButton(
          child: const Text('USUŃ'),

          onPressed: () {
            Navigator.pop(context);
            onDeletePressed();
          },
        ),

        FlatButton(
          child: const Text('EDYTUJ'),

          onPressed: () {
            Navigator.pop(context);
            onEditPressed();
          },
        ),

        FlatButton(
          child: const Text('ĆWICZ'),

          onPressed: (deck.cards.length == 0) ? null : () {
            Navigator.pop(context);
            onExercisePressed();
          },
        ),
      ],
    );
  }
}
