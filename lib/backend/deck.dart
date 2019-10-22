import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

export 'deck/models.dart';
export 'deck/repositories.dart';
export 'deck/requests.dart';
export 'deck/view_models.dart';

class DeckFacade {
  final DeckRepository deckRepository;
  final BoxFacade boxFacade;
  final CardFacade cardFacade;

  DeckFacade({
    @required this.deckRepository,
    @required this.boxFacade,
    @required this.cardFacade,
  })
      :
        assert(deckRepository != null),
        assert(boxFacade != null),
        assert(cardFacade != null);

  /// Creates a brand-new deck according to given request.
  Future<void> create(CreateDeckRequest request) async {
    // Create boxes
    await boxFacade.createMany(request.boxes);

    // Create cards
    await cardFacade.createMany(request.cards);

    // Create deck
    final deck = DeckModel.create().copyWith(
      id: request.id,
      name: request.name,
    );

    await deckRepository.add(deck);
  }

  /// Updates related deck according to given request.
  Future<void> update(UpdateDeckRequest request) async {
    // Create, update and delete boxes
    await boxFacade.createMany(request.boxesToCreate);
    await boxFacade.updateMany(request.boxesToUpdate);
    await boxFacade.deleteMany(request.boxesToDelete);

    // Create, update and delete cards
    await cardFacade.createMany(request.cardsToCreate);
    await cardFacade.updateMany(request.cardsToUpdate);
    await cardFacade.deleteMany(request.cardsToDelete);

    // Update deck
    if (request.name.isPresent) {
      await deckRepository.updateName(request.id, request.name.value);
    }
  }

  /// Updates the [DeckModel.exercisedAt] property to current date and time.
  Future<void> touchExercisedAt(DeckModel deck) async {
    await deckRepository.updateExercisedAt(deck.id, DateTime.now());
  }

  /// Returns deck with specified id.
  /// Throws an error if no such deck exists.
  Future<DeckModel> findById(Id id) async {
    return (await deckRepository.findById(id)).orElseThrow(() {
      return 'deck not found: [id=$id]';
    });
  }

  /// Returns all decks that match given status.
  Future<List<DeckModel>> findByStatus(DeckStatus status) async {
    return deckRepository.findByStatus(status);
  }

  /// Returns all boxes that belong to specified deck.
  Future<List<BoxModel>> findBoxes(DeckModel deck) async {
    return await boxFacade.findByDeck(deck);
  }

  /// Returns all cards that belong to specified deck.
  Future<List<CardModel>> findCards(DeckModel deck) async {
    return await cardFacade.findByDeck(deck);
  }

  /// Upgrades specified [DeckModel] into [DeckViewModel].
  Future<DeckViewModel> upgrade(DeckModel deck) async {
    return DeckViewModel(
      deck: deck,
      boxes: List.unmodifiable(await findBoxes(deck)),
      cards: List.unmodifiable(await findCards(deck)),
    );
  }

  /// Upgrades all specified [DeckModel]s into [DeckViewModel]s.
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

    // Delete boxes
    for (final box in await findBoxes(deck)) {
      await boxFacade.delete(box);
    }

    // Delete deck
    await deckRepository.remove(deck.id);
  }
}
