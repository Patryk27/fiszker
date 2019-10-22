import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

@immutable
class UpdateDeckRequest {
  /// Id of the [DeckModel] to update.
  final Id id;

  /// If present, the deck's name will be updated to specified value.
  final Optional<String> name;

  /// List of boxes that should be created alongside the deck.
  final List<CreateBoxRequest> boxesToCreate;

  /// List of boxes that should be updated alongside the deck.
  final List<UpdateBoxRequest> boxesToUpdate;

  /// List of boxes that should be deleted alongside the deck.
  final List<BoxModel> boxesToDelete;

  /// List of cards that should be created alongside the deck.
  final List<CreateCardRequest> cardsToCreate;

  /// List of cards that should be updated alongside the deck.
  final List<UpdateCardRequest> cardsToUpdate;

  /// List of cards that should be deleted alongside the deck.
  final List<CardModel> cardsToDelete;

  UpdateDeckRequest({
    @required this.id,
    @required this.name,

    @required this.boxesToCreate,
    @required this.boxesToUpdate,
    @required this.boxesToDelete,

    @required this.cardsToCreate,
    @required this.cardsToUpdate,
    @required this.cardsToDelete,
  })
      : assert(id != null),
        assert(name != null),

        assert(boxesToCreate != null),
        assert(boxesToUpdate != null),
        assert(boxesToDelete != null),

        assert(cardsToCreate != null),
        assert(cardsToUpdate != null),
        assert(cardsToDelete != null);

  /// Transforms given models into an [UpdateDeckRequest].
  static UpdateDeckRequest fromModels({
    @required DeckModel oldDeck,
    @required DeckModel newDeck,

    @required List<BoxModel> oldBoxes,
    @required List<BoxModel> newBoxes,

    @required List<CardModel> oldCards,
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
        .map((newCard) => CreateCardRequest.fromModel(card: newCard))
        .toList();

    // Determine which cards should be updated
    var cardsToUpdate = newCards
        .where((newCard) => oldCardsMap.containsKey(newCard.id))
        .map((newCard) => UpdateCardRequest.fromModels(oldCard: oldCardsMap[newCard.id], newCard: newCard))
        .toList();

    // Determine which cards should be deleted
    var cardsToDelete = oldCards
        .where((oldCard) => !newCardsMap.containsKey(oldCard.id))
        .toList();

    return UpdateDeckRequest(
      id: oldDeck.id,

      name: (newDeck.name == oldDeck.name)
          ? Optional.empty()
          : Optional.of(newDeck.name),

      // @todo
      boxesToCreate: [],

      // @todo
      boxesToUpdate: [],

      // @todo
      boxesToDelete: [],

      cardsToCreate: cardsToCreate,
      cardsToUpdate: cardsToUpdate,
      cardsToDelete: cardsToDelete,
    );
  }
}
