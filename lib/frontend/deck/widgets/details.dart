import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart' as frontend;
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
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
        assert(onDeletePressed != null),
        assert(onExercisePressed != null),
        assert(onEditPressed != null);

  @override
  Widget build(BuildContext context) {
    return frontend.BottomSheet(
      title: Optional.of(deck.deck.name),

      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          DeckDetail(
            title: 'Liczba fiszek:',
            value: deck.cards.length.toString(),
          ),

          const SizedBox(height: 20),

          DeckDetail(
            title: 'Utworzony:',
            value: timeago.format(deck.deck.createdAt),
          ),

          const SizedBox(height: 20),

          DeckDetail(
            title: 'Ostatnio ćwiczony:',
            value: deck.deck.exercisedAt.map(timeago.format).orElse('-'),
          ),
        ],
      ),

      actions: [
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
    );
  }
}
