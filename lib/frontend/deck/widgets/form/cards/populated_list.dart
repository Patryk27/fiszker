import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'list/item.dart';

class CardPopulatedList extends StatelessWidget {
  final List<CardModel> cards;
  final void Function(CardModel card) onCardTapped;

  CardPopulatedList({
    @required this.cards,
    @required this.onCardTapped,
  })
      : assert(cards != null),
        assert(onCardTapped != null);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: cards.length,

      itemBuilder: (BuildContext context, int index) {
        final card = cards[index];

        return CardListItem(
          card: card,

          onTapped: () {
            onCardTapped(card);
          },
        );
      },
    );
  }
}
