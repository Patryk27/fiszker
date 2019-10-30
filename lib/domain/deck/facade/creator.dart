import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

/// This class encapsulates all the logic related to creating decks.
/// It's a part of [DeckFacade] and shouldn't be used standalone.
class DeckCreator {
  BoxStorage boxStorage;
  CardStorage cardStorage;
  DeckStorage deckStorage;

  DeckCreator(this.boxStorage, this.cardStorage, this.deckStorage)
      : assert(boxStorage != null),
        assert(cardStorage != null),
        assert(deckStorage != null);

  /// See: [DeckFacade.create]
  Future<void> create(DeckEntity deck) async {
    // Create deck
    await deckStorage.add(deck.deck);

    // Create boxes
    for (final box in deck.boxes) {
      assert(box.deckId == deck.deck.id);
      await boxStorage.add(box);
    }

    // Create cards
    for (final card in deck.cards) {
      assert(card.deckId == deck.deck.id);
      await cardStorage.add(card);
    }
  }
}
