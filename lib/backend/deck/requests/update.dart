import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

@immutable
class UpdateDeckRequest {
  final DeckModel deck;
  final Optional<String> name;
  final List<CreateCardRequest> cardsToCreate;
  final List<UpdateCardRequest> cardsToUpdate;
  final List<CardModel> cardsToDelete;

  UpdateDeckRequest({
    @required this.deck,
    @required this.name,
    @required this.cardsToCreate,
    @required this.cardsToUpdate,
    @required this.cardsToDelete,
  })
      : assert(deck != null),
        assert(name != null),
        assert(cardsToCreate != null),
        assert(cardsToUpdate != null),
        assert(cardsToDelete != null);

  static UpdateDeckRequest build({
    @required DeckModel oldDeck,
    @required List<CardModel> oldCards,

    @required DeckModel newDeck,
    @required List<CardModel> newCards,
  }) {
    final oldCardsMap = Map.fromIterable(
      oldCards,
      key: (cardId) => cardId.toString(),
    );

    final newCardsMap = Map.fromIterable(
      newCards,
      key: (cardId) => cardId.toString(),
    );

    // Determine which cards should be created
    var cardsToCreate = newCards
        .where((newCard) => !oldCardsMap.containsKey(newCard.id))
        .map((newCard) => CreateCardRequest.build(deckId: oldDeck.id, card: newCard))
        .toList();

    // Determine which cards should be updated
    var cardsToUpdate = newCards
        .where((newCard) => oldCardsMap.containsKey(newCard.id))
        .map((newCard) => UpdateCardRequest.build(oldCard: oldCardsMap[newCard.id], newCard: newCard))
        .toList();

    // Determine which cards should be deleted
    var cardsToDelete = oldCards
        .where((oldCard) => !newCardsMap.containsKey(oldCard.id))
        .toList();

    return UpdateDeckRequest(
      deck: oldDeck,
      name: (newDeck.name == oldDeck.name) ? Optional.empty() : Optional.of(newDeck.name),
      cardsToCreate: cardsToCreate,
      cardsToUpdate: cardsToUpdate,
      cardsToDelete: cardsToDelete,
    );
  }
}
