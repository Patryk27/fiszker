import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

export 'card/models.dart';
export 'card/repositories.dart';
export 'card/requests.dart';

/// This class encapsulates all actions that can be performed on [CardModel]s.
/// It provides a pretty low-level interface meant for [DeckFacade].
class CardFacade {
  final CardRepository cardRepository;

  CardFacade({
    @required this.cardRepository,
  }) : assert(cardRepository != null);

  /// Creates a brand-new card according to given request.
  Future<void> create(CreateCardRequest request) async {
    var card = CardModel.create(
      deckId: request.deckId,
      boxId: request.boxId,
    ).copyWith(
      front: request.front,
      back: request.back,
    );

    await cardRepository.add(card);
  }

  /// Creates a list of brand-new cards according to given requests.
  Future<void> createMany(List<CreateCardRequest> requests) async {
    for (final request in requests) {
      await create(request);
    }
  }

  /// Updates related card according to given request.
  Future<void> update(UpdateCardRequest request) async {
    if (request.front.isPresent) {
      await cardRepository.updateFront(request.id, request.front.value);
    }

    if (request.back.isPresent) {
      await cardRepository.updateBack(request.id, request.back.value);
    }
  }

  /// Updates related cards according to given requests.
  Future<void> updateMany(List<UpdateCardRequest> requests) async {
    for (final request in requests) {
      await update(request);
    }
  }

  /// Returns all cards that belong to given deck.
  Future<List<CardModel>> findByDeck(DeckModel deck) async {
    return await cardRepository.findByDeckId(deck.id);
  }

  /// Deletes given card.
  Future<void> delete(CardModel card) async {
    await cardRepository.remove(card.id);
  }

  /// Deletes given cards.
  Future<void> deleteMany(List<CardModel> cards) async {
    for (final card in cards) {
      await delete(card);
    }
  }
}
