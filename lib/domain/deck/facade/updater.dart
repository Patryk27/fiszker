import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import 'validator.dart';

/// This class encapsulates all the logic related to updating decks.
/// It's a part of [DeckFacade] and shouldn't be used standalone.
class DeckUpdater {
  BoxStorage boxStorage;
  CardStorage cardStorage;
  DeckStorage deckStorage;
  DeckValidator deckValidator;

  DeckUpdater(this.boxStorage, this.cardStorage, this.deckStorage, this.deckValidator)
      : assert(boxStorage != null),
        assert(cardStorage != null),
        assert(deckStorage != null),
        assert(deckValidator != null);

  /// See: [DeckFacade.update]
  Future<void> update(DeckEntity deck) async {
    final deckId = deck.deck.id;

    deckValidator.validate(deck);
    // @todo transaction

    // First we have to load current version of the deck, its boxes and cards - we'll use all those data to compare how
    // the models have changed and then update them accordingly
    final oldDeck = (await deckStorage.findById(deckId)).orElseThrow(() => 'deck with id `$deckId` was not found');
    final oldBoxes = await boxStorage.findByDeckId(deckId);
    final oldCards = await cardStorage.findByDeckId(deckId);

    // Step 1/3: Update models
    await _updateDeck(oldDeck, deck.deck);
    await _updateBoxes(indexModels(oldBoxes), indexModels(deck.boxes));
    await _updateCards(indexModels(oldCards), indexModels(deck.cards));
  }

  Future<void> _updateDeck(DeckModel oldDeck, DeckModel newDeck) async {
    assert(oldDeck.id == newDeck.id);

    await deckStorage.update(newDeck.id,
      name: compare(oldDeck.name, newDeck.name),
      status: compare(oldDeck.status, newDeck.status),
    );
  }

  Future<void> _updateBoxes(Map<Id, BoxModel> oldBoxes, Map<Id, BoxModel> newBoxes) async {
    final ids = oldBoxes.keys.toSet().union(newBoxes.keys.toSet());

    for (final id in ids) {
      final oldBox = oldBoxes[id];
      final newBox = newBoxes[id];

      if (oldBox == null) {
        await boxStorage.add(newBox);
      } else if (newBox == null) {
        await boxStorage.remove(oldBox.id);
      } else {
        await boxStorage.update(newBox.id,
          index: compare(oldBox.index, newBox.index),
          name: compare(oldBox.name, newBox.name),
        );
      }
    }
  }

  Future<void> _updateCards(Map<Id, CardModel> oldCards, Map<Id, CardModel> newCards) async {
    final ids = oldCards.keys.toSet().union(newCards.keys.toSet());

    for (final id in ids) {
      final oldCard = oldCards[id];
      final newCard = newCards[id];

      if (oldCard == null) {
        await cardStorage.add(newCard);
      } else if (newCard == null) {
        await cardStorage.remove(oldCard.id);
      } else {
        await cardStorage.update(newCard.id,
          boxId: compare(oldCard.boxId, newCard.boxId),
          front: compare(oldCard.front, newCard.front),
          back: compare(oldCard.back, newCard.back),
        );
      }
    }
  }
}
