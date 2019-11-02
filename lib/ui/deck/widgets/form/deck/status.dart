import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';

/// This widget models the "Deck status" form field.
/// It's a part of the [DeckForm], not meant for standalone use.
class DeckStatusField extends StatefulWidget {
  final DeckModel deck;
  final void Function(DeckModel deck) onChanged;

  DeckStatusField({
    @required this.deck,
    @required this.onChanged,
  })
      : assert(deck != null),
        assert(onChanged != null);

  @override
  State<StatefulWidget> createState() => _DeckStatusFieldState();
}

class _DeckStatusFieldState extends State<DeckStatusField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: widget.deck.status,

      decoration: InputDecoration(
        labelText: 'Status',
        alignLabelWithHint: true,
      ),

      items: buildItems(),

      onChanged: (value) {
        widget.onChanged(
          widget.deck.copyWith(
            status: value,
          ),
        );
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
