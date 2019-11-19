import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

/// This class encapsulates all the logic related to deleting decks.
/// It's a part of [DeckFacade] and shouldn't be used standalone.
class DeckDeleter {
  BoxStorage boxStorage;
  CardStorage cardStorage;
  DeckStorage deckStorage;

  DeckDeleter(this.boxStorage, this.cardStorage, this.deckStorage)
      : assert(boxStorage != null),
        assert(cardStorage != null),
        assert(deckStorage != null);

  /// See: [DeckFacade.delete]
  Future<void> delete(DeckEntity deck) async {
    // @todo transaction

    for (final card in await cardStorage.findByDeckId(deck.deck.id)) {
      await cardStorage.remove(card.id);
    }

    for (final box in await boxStorage.findByDeckId(deck.deck.id)) {
      await boxStorage.remove(box.id);
    }

    await deckStorage.remove(deck.deck.id);
  }
}
