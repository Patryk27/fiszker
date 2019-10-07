import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

class CardFacade {
  CardFacade({
    @required this.cardRepository,
  }) : assert(cardRepository != null);

  final CardRepository cardRepository;

  /// Creates a brand-new [CardModel] according to specified [request].
  Future<CardModel> create(CreateCardRequest request) async {
    var card = CardModel.create(deckId: request.deckId).copyWith(
      front: request.front,
      back: request.back,
    );

    await cardRepository.add(card);

    return card;
  }

  /// Updates an already existing [CardModel] according to specified [request].
  Future<void> update(UpdateCardRequest request) async {
    if (request.front.isPresent) {
      await cardRepository.updateFront(request.card.id, request.front.value);
    }

    if (request.back.isPresent) {
      await cardRepository.updateBack(request.card.id, request.back.value);
    }
  }

  /// Deletes specified [card].
  Future<void> delete(CardModel card) async {
    await cardRepository.remove(card.id);
  }

  /// Returns all cards that belong to specified deck.
  Future<List<CardModel>> findByDeck(DeckModel deck) async {
    return await cardRepository.findByDeckId(deck.id);
  }
}
