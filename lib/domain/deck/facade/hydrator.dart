import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

class DeckHydrator {
  BoxStorage boxStorage;
  CardStorage cardStorage;

  DeckHydrator(this.boxStorage, this.cardStorage)
      : assert(boxStorage != null),
        assert(cardStorage != null);

  Future<DeckEntity> hydrate(DeckModel deck) async {
    return DeckEntity(
      deck: deck,
      boxes: await boxStorage.findByDeckId(deck.id),
      cards: await cardStorage.findByDeckId(deck.id),
    );
  }
}