import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import 'facade/creator.dart';
import 'facade/deleter.dart';
import 'facade/hydrator.dart';
import 'facade/searcher.dart';
import 'facade/updater.dart';
import 'facade/validator.dart';

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
    final deckValidator = DeckValidator();

    return DeckFacade._(
      DeckCreator(boxStorage, cardStorage, deckStorage, deckValidator),
      DeckUpdater(boxStorage, cardStorage, deckStorage, deckValidator),
      DeckSearcher(deckStorage, deckHydrator),
      DeckDeleter(boxStorage, cardStorage, deckStorage),
    );
  }

  /// Creates a new deck with default settings (predefined boxes) and specified name, and returns its id.
  ///
  /// It's meant to be a handler for the deck form and thus it doesn't allow arbitrary changes (that's why you can
  /// specify just the deck's name).
  ///
  /// # Errors
  ///
  /// - Throws an exception if specified deck name is invalid.
  Future<Id> create(String deckName) async {
    return await deckCreator.create(deckName);
  }

  /// Saves changes to specified deck.
  ///
  /// It's meant to be a handler for the deck form and thus it doesn't allow arbitrary changes (e.g. you can't change
  /// the "exercised at" properties using this method).
  ///
  /// # Errors
  ///
  /// - Throws an exception if specified deck is invalid (e.g. boxes have mixed-up indexes).
  Future<void> update(DeckEntity deck) async {
    await deckUpdater.update(deck);
  }

  /// Returns deck with specified name.
  ///
  /// # Errors
  ///
  /// - Throws an exception if no such deck exists.
  Future<DeckEntity> findById(Id id) async {
    return await deckSearcher.findById(id);
  }

  /// Returns decks with specified status.
  Future<List<DeckEntity>> findByStatus(DeckStatus status) async {
    return await deckSearcher.findByStatus(status);
  }

  /// Removes specified deck (and all of its related models) from the database.
  Future<void> delete(DeckEntity deck) async {
    await deckDeleter.delete(deck);
  }
}
