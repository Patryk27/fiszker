import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'list/item.dart';

class DeckList extends StatelessWidget {
  final List<DeckViewModel> decks;
  final void Function(DeckViewModel deck) onDeckTapped;
  final void Function(DeckViewModel deck) onDeckLongPressed;

  DeckList({
    @required this.decks,
    @required this.onDeckTapped,
    @required this.onDeckLongPressed,
  })
      : assert(decks != null),
        assert(onDeckTapped != null),
        assert(onDeckLongPressed != null);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: decks.length,

      itemBuilder: (context, index) {
        final deck = decks[index];

        return DeckListItem(
          deck: deck,

          onTapped: () {
            onDeckTapped(deck);
          },

          onLongPressed: () {
            onDeckLongPressed(deck);
          },
        );
      },
    );
  }
}
