import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'deck/name.dart';

/// This widgets models the "Deck" section of the [DeckForm] widget.
class DeckFormDeckSection extends StatefulWidget {
  final DeckModel deck;
  final void Function(DeckModel deck) onDeckUpdated;

  DeckFormDeckSection({
    @required this.deck,
    @required this.onDeckUpdated,
  })
      : assert(deck != null),
        assert(onDeckUpdated != null);

  @override
  _DeckFormDeckSectionState createState() {
    return _DeckFormDeckSectionState();
  }
}

class _DeckFormDeckSectionState extends State<DeckFormDeckSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        DeckNameField(
          deck: widget.deck,
          onChanged: widget.onDeckUpdated,
        ),
      ],
    );
  }
}
