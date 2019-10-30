import 'package:fiszker/database.dart';
import 'package:optional/optional.dart';

class InMemoryDeckStorage implements DeckStorage {
  final Map<Id, Map<String, dynamic>> _decks = {};

  @override
  Future<void> add(DeckModel deck) async {
    _assertNotExists(deck.id);
    _decks[deck.id] = deck.serialize();

    print('(db) Deck added: $deck');
  }

  Future<void> update(Id id, {
    Optional<String> name = const Optional.empty(),
    Optional<DeckStatus> status = const Optional.empty(),
    Optional<Optional<DateTime>> exercisedAt = const Optional.empty(),
  }) async {
    _assertExists(id);

    _decks.update(id, (deck) {
      return DeckModel.deserialize(deck).copyWith(
        name: name.orElse(null),
        status: status.orElse(null),
        exercisedAt: exercisedAt.orElse(null),
      ).serialize();
    });

    print('(db) Deck updated: id=$id, name=$name, status=$status, exercisedAt=$exercisedAt');
  }

  @override
  Future<Optional<DeckModel>> findById(Id id) async {
    return Optional
        .ofNullable(_decks[id])
        .map(DeckModel.deserialize);
  }

  @override
  Future<List<DeckModel>> findByStatus(DeckStatus status) async {
    return _decks.values
        .map(DeckModel.deserialize)
        .where((deck) => deck.status == status)
        .toList();
  }

  @override
  Future<void> remove(Id id) async {
    _assertExists(id);
    _decks.remove(id);

    print('(db) Deck removed: id=$id');
  }

  /// Throws an exception if there's a deck with specified id in the database.
  void _assertNotExists(Id id) {
    if (_decks.containsKey(id)) {
      throw 'storage already contains deck [id=$id]';
    }
  }

  /// Throws an exception if there's no deck with specified id in the database.
  void _assertExists(Id id) {
    if (!_decks.containsKey(id)) {
      throw 'storage does not contain deck [id=$id]';
    }
  }
}
