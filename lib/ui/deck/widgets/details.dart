import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart' as ui;
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class DeckDetails extends StatelessWidget {
  final DeckEntity deck;
  final void Function() onDeletePressed;
  final Optional<void Function()> onExercisePressed;
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
    return ui.BottomSheet(
      title: Optional.of(deck.deck.name),

      body: Details(
        children: [
          // Number of cards
          Detail(
            title: 'Liczba fiszek:',
            value: Optional.of(deck.cards.length.toString()),
          ),

          // Number of boxes
          Detail(
            title: 'Liczba pudełek:',
            value: Optional.of(deck.boxes.length.toString()),
          ),

          // Created at
          Detail.ago(
            title: 'Utworzony:',
            value: Optional.of(deck.deck.createdAt),
          ),

          // Exercised at
          Detail.ago(
            title: 'Ostatnio ćwiczony:',
            value: deck.deck.exercisedAt,
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
          onPressed: onExercisePressed.orElse(null),
        ),
      ],
    );
  }
}
