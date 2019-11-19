import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import 'validator.dart';

/// This class encapsulates all the logic related to creating decks.
/// It's a part of [DeckFacade] and shouldn't be used standalone.
class DeckCreator {
  BoxStorage boxStorage;
  CardStorage cardStorage;
  DeckStorage deckStorage;
  DeckValidator deckValidator;

  DeckCreator(this.boxStorage, this.cardStorage, this.deckStorage, this.deckValidator)
      : assert(boxStorage != null),
        assert(cardStorage != null),
        assert(deckStorage != null),
        assert(deckValidator != null);

  /// See: [DeckFacade.create]
  Future<Id> create(String name) async {
    final deck = DeckEntity.create(name: name);

    deckValidator.validate(deck);

    // @todo transaction

    await deckStorage.add(deck.deck);

    for (final box in deck.boxes) {
      assert(box.deckId == deck.deck.id);
      await boxStorage.add(box);
    }

    for (final card in deck.cards) {
      assert(card.deckId == deck.deck.id);
      await cardStorage.add(card);
    }

    return deck.deck.id;
  }
}
