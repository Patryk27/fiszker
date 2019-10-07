import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

@immutable
class CreateDeckRequest {
  final Id id;
  final String name;
  final List<CreateCardRequest> cards;

  CreateDeckRequest({
    @required this.id,
    @required this.name,
    @required this.cards,
  })
      : assert(id != null),
        assert(name != null),
        assert(cards != null);

  static CreateDeckRequest build({
    @required DeckModel deck,
    @required List<CardModel> cards,
  }) {
    return CreateDeckRequest(
      id: deck.id,
      name: deck.name,

      cards: cards.map((card) {
        return CreateCardRequest.build(
          deckId: deck.id,
          card: card,
        );
      }).toList(),
    );
  }
}
