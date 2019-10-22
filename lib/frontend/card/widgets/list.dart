import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'list/item.dart';

class CardList extends StatelessWidget {
  final List<CardModel> cards;
  final void Function(CardModel card) onCardTapped;

  CardList({
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

      itemBuilder: (context, index) {
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
