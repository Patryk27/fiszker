import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import 'facade/creator.dart';
import 'facade/deleter.dart';
import 'facade/hydrator.dart';
import 'facade/searcher.dart';
import 'facade/updater.dart';

// @todo implement validation
class DeckFacade {
  DeckCreator deckCreator;
  DeckUpdater deckUpdater;
  DeckSearcher deckSearcher;
  DeckDeleter deckDeleter;

  DeckFacade._(this.deckCreator, this.deckUpdater, this.deckSearcher, this.deckDeleter)
      : assert(deckCreator != null),
        assert(deckUpdater != null),
        assert(deckSearcher != null),
        assert(deckDeleter != null);

  static DeckFacade build(BoxStorage boxStorage, CardStorage cardStorage, DeckStorage deckStorage) {
    final deckHydrator = DeckHydrator(boxStorage, cardStorage);

    return DeckFacade._(
      DeckCreator(boxStorage, cardStorage, deckStorage),
      DeckUpdater(boxStorage, cardStorage, deckStorage),
      DeckSearcher(deckStorage, deckHydrator),
      DeckDeleter(boxStorage, cardStorage, deckStorage),
    );
  }

  Future<void> create(String deckName) async {
    await deckCreator.create(deckName);
  }

  Future<void> update(DeckEntity deck) async {
    await deckUpdater.update(deck);
  }

  Future<DeckEntity> findById(Id id) async {
    return await deckSearcher.findById(id);
  }

  Future<List<DeckEntity>> findByStatus(DeckStatus status) async {
    return await deckSearcher.findByStatus(status);
  }

  Future<void> delete(DeckEntity deck) async {
    await deckDeleter.delete(deck);
  }
}
