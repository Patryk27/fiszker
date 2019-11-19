import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

/// This class encapsulates all the logic related to validating decks.
/// It's a part of [DeckFacade] and shouldn't be used standalone.
class DeckValidator {
  /// Throws an exception if given deck's invalid.
  ///
  /// This method is not meant to be UI-friendly - it's more of a "last resort check" and thus the thrown exception will
  /// not be translated etc.
  void validate(DeckEntity deck) {
    try {
      _validateDeck(deck.deck);
      _validateBoxes(deck.deck, deck.boxes);
      _validateCards(deck.deck, deck.boxes, deck.cards);
    } catch (err) {
      throw 'specified deck is invalid: $err';
    }
  }

  void _validateDeck(DeckModel deck) {
    if (deck.name.isEmpty) {
      throw 'its name is blank';
    }
  }

  void _validateBoxes(DeckModel deck, List<BoxModel> boxes) {
    if (boxes.length < 2) {
      throw 'it does not contain at least two boxes';
    }

    // Ensure all boxes have correct (unique, continuous) indexes
    final boxesMap = Map.fromIterable(boxes, key: (box) => box.index);

    for (var i = 1; i <= boxes.length; i += 1) {
      if (!boxesMap.containsKey(i)) {
        throw 'it does not contain box with index `$i`';
      }
    }

    // Ensure all boxes are named and belong to this deck
    for (final box in boxes) {
      if (box.name.isEmpty) {
        throw 'it contains an unnamed box with id `${box.id}`';
      }

      if (box.deckId != deck.id) {
        throw 'it contains an alien box with id `${box.id}`';
      }
    }
  }

  void _validateCards(DeckModel deck, List<BoxModel> boxes, List<CardModel> cards) {
    final boxIds = Set.of(boxes.map((box) => box.id));

    for (final card in cards) {
      if (!boxIds.contains(card.boxId)) {
        throw 'it contains an alien card with id `${card.id}`';
      }
    }
  }
}
