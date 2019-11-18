import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/i18n.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

/// This widget models a [DropdownButtonFormField] that enables user to choose which deck they want to exercise.
class ExerciseBoxDropdown extends StatefulWidget {
  final DeckEntity deck;
  final BoxModel value;
  final void Function(BoxModel value) onChanged;

  ExerciseBoxDropdown({
    @required this.deck,
    @required this.value,
    @required this.onChanged,
  })
      : assert(deck != null),
        assert(value != null),
        assert(onChanged != null);

  @override
  State<ExerciseBoxDropdown> createState() => _ExerciseBoxDropdownState();
}

class _ExerciseBoxDropdownState extends State<ExerciseBoxDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: widget.value,
      onChanged: widget.onChanged,

      decoration: const InputDecoration(
        labelText: 'Wybierz pudełko',
        alignLabelWithHint: true,
      ),

      items: widget.deck
          .findOccupiedBoxes()
          .map(buildItem)
          .toList(),
    );
  }

  DropdownMenuItem<BoxModel> buildItem(BoxModel box) {
    final cards = inflector.pluralize(
      InflectorVerb.flashcard,
      InflectorCase.nominative,
      widget.deck.countCardsInsideBox(box),
    );

    final hint = box.exercisedAt
        .map((exercisedAt) => '$cards, ostatnio: ${timeago.format(exercisedAt)}')
        .orElse(cards);

    return DropdownMenuItem(
      value: box,

      child: Row(
        children: [
          Text("${box.name} "),

          Opacity(
            opacity: 0.6,
            child: Text("($hint)", textScaleFactor: 0.8),
          ),
        ],
      ),
    );
  }
}
