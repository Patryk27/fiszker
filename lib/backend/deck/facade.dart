import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

class DeckFacade {
  DeckFacade({
    @required this.deckRepository,
    @required this.cardFacade,
  })
      :
        assert(deckRepository != null),
        assert(cardFacade != null);

  final DeckRepository deckRepository;
  final CardFacade cardFacade;

  /// Creates a brand-new [DeckModel] according to specified [request].
  Future<DeckModel> create(CreateDeckRequest request) async {
    // Create cards
    for (final card in request.cards) {
      await cardFacade.create(card);
    }

    // Create deck
    var deck = DeckModel.create().copyWith(
      id: request.id,
      name: request.name,
    );

    await deckRepository.add(deck);

    return deck;
  }

  /// Updates an already existing [DeckModel] according to specified [request].
  Future<void> update(UpdateDeckRequest request) async {
    // Creates new cards
    for (final card in request.cardsToCreate) {
      await cardFacade.create(card);
    }

    // Update existing cards
    for (final card in request.cardsToUpdate) {
      await cardFacade.update(card);
    }

    // Remove old cards
    for (final card in request.cardsToDelete) {
      await cardFacade.delete(card);
    }

    // Update deck
    if (request.name.isPresent) {
      await deckRepository.updateName(request.deck.id, request.name.value);
    }
  }

  /// Updates the [DeckModel.exercisedAt] property to current date and time.
  Future<void> touchExercisedAt(DeckModel deck) async {
    await deckRepository.updateExercisedAt(deck.id, DateTime.now());
  }

  /// Returns all [CardModel]s that belong to specified deck.
  Future<List<CardModel>> findCards(DeckModel deck) async {
    return cardFacade.findByDeck(deck);
  }

  /// Returns the [DeckModel] with specified id.
  /// Throws an error if no such deck exists.
  Future<DeckModel> findById(Id id) async {
    return (await deckRepository.findById(id)).orElseThrow(() {
      return 'deck not found: [id=$id]';
    });
  }

  /// Returns all [DeckModel]s that match specified [status].
  Future<List<DeckModel>> findByStatus(DeckStatus status) async {
    return deckRepository.findByStatus(status);
  }

  /// Upgrades specified [DeckModel] into [DeckViewModel].
  Future<DeckViewModel> upgrade(DeckModel deck) async {
    return DeckViewModel(
      deck: deck,
      cards: await findCards(deck),
    );
  }

  /// Upgrades all specified [DeckModel] into [DeckViewModel].
  Future<List<DeckViewModel>> upgradeMany(List<DeckModel> decks) async {
    final List<DeckViewModel> result = [];

    for (final deck in decks) {
      result.add(
        await upgrade(deck),
      );
    }

    return result;
  }

  /// Deletes given [deck].
  Future<void> delete(DeckModel deck) async {
    // Delete cards
    for (final card in await findCards(deck)) {
      await cardFacade.delete(card);
    }

    // Delete deck
    await deckRepository.remove(deck.id);
  }
}
