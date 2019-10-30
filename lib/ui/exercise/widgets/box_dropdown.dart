import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/i18n.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:timeago/timeago.dart' as timeago;

/// This widget models a [DropdownButtonFormField] that enables user to choose which deck they want to exercise.
class ExerciseBoxDropdown extends StatefulWidget {
  final DeckEntity deck;
  final void Function(BoxModel value) onChanged;

  ExerciseBoxDropdown({
    @required this.deck,
    @required this.onChanged,
  })
      : assert(deck != null),
        assert(onChanged != null);

  @override
  State<ExerciseBoxDropdown> createState() => _ExerciseBoxDropdownState();
}

class _ExerciseBoxDropdownState extends State<ExerciseBoxDropdown> {
  Optional<BoxModel> value = const Optional.empty();
  List<DropdownMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value.orElse(null),
      items: items,

      decoration: InputDecoration(
        labelText: 'Wybierz pudełko',
        alignLabelWithHint: true,
      ),

      onChanged: (value) {
        setState(() {
          this.value = Optional.of(value);
        });

        widget.onChanged(value);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    items = buildItems();

    if (items.isNotEmpty) {
      value = Optional.of(items[0].value);
      widget.onChanged(value.value);
    }
  }

  List<DropdownMenuItem> buildItems() {
    var boxes = widget.deck.boxes;

    // Skip over all the empty boxes
    boxes = boxes.where((box) {
      return widget.deck.countCardsInsideBox(box) > 0;
    }).toList();

    // Build items
    return boxes
        .map(buildItem)
        .toList();
  }

  DropdownMenuItem buildItem(BoxModel box) {
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
