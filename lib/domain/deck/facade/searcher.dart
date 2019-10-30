import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import 'hydrator.dart';

/// This class encapsulates all the logic related to finding decks.
/// It's a part of [DeckFacade] and shouldn't be used standalone.
class DeckSearcher {
  DeckStorage deckStorage;
  DeckHydrator deckHydrator;

  DeckSearcher(this.deckStorage, this.deckHydrator)
      : assert(deckStorage != null),
        assert(deckHydrator != null);

  /// See: [DeckFacade.findById]
  Future<DeckEntity> findById(Id id) async {
    final deck = await deckStorage.findById(id);

    if (!deck.isPresent) {
      throw 'deck [id=$id] does not exist';
    }

    return await deckHydrator.hydrate(deck.value);
  }

  /// See: [DeckFacade.findByStatus]
  Future<List<DeckEntity>> findByStatus(DeckStatus status) async {
    final decks = <DeckEntity>[];

    for (final deck in await deckStorage.findByStatus(status)) {
      decks.add(
        await deckHydrator.hydrate(deck),
      );
    }

    return decks;
  }
}
