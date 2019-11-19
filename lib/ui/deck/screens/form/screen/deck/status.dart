import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';

import '../../bloc.dart';

/// This widget models the "Deck status" form field.
/// It's a part of the [DeckForm], not meant for standalone use.
class DeckStatusField extends StatefulWidget {
  final DeckEntity deck;

  DeckStatusField({
    @required this.deck,
  }) : assert(deck != null);

  @override
  State<StatefulWidget> createState() => _DeckStatusFieldState();
}

class _DeckStatusFieldState extends State<DeckStatusField> {
  @override
  Widget build(BuildContext context) {
    final deck = widget.deck;

    return DropdownButtonFormField(
      value: deck.deck.status,

      decoration: const InputDecoration(
        labelText: 'Status',
        alignLabelWithHint: true,
      ),

      items: buildItems(),

      onChanged: (status) {
        final newDeck = deck.changeStatus(status);

        DeckFormBloc
            .of(context)
            .add(Submit(newDeck, notification: DeckStatusChanged()));
      },
    );
  }

  List<DropdownMenuItem> buildItems() {
    return [
      buildItem(DeckStatus.active, 'Aktywny', 'jesteś w trakcie nauki tych fiszek'),
      buildItem(DeckStatus.completed, 'Ukończony', 'udało Ci się ukończyć wszystkie fiszki'),
      buildItem(DeckStatus.archived, 'Zarchiwizowany', 'dla zestawów \'odłożonych na bok\''),
    ];
  }

  DropdownMenuItem buildItem(DeckStatus value, String name, String description) {
    return DropdownMenuItem(
      value: value,

      child: Row(
        children: [
          Text("$name "),

          Opacity(
            opacity: 0.6,
            child: Text("($description)", textScaleFactor: 0.8),
          ),
        ],
      ),
    );
  }
}
