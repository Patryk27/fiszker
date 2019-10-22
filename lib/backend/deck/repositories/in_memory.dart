import 'package:fiszker/backend.dart';
import 'package:optional/optional.dart';

class InMemoryDeckRepository implements DeckRepository {
  final Map<Id, Map<String, dynamic>> _decks = {};

  @override
  Future<void> add(DeckModel deck) async {
    _assertNotExists(deck.id);

    _decks[deck.id] = deck.serialize();
  }

  @override
  Future<void> updateName(Id id, String name) async {
    _assertExists(id);

    _decks.update(id, (deck) {
      return DeckModel
          .deserialize(deck)
          .copyWith(name: name)
          .serialize();
    });
  }

  @override
  Future<void> updateStatus(Id id, DeckStatus status) async {
    _assertExists(id);

    _decks.update(id, (deck) {
      return DeckModel
          .deserialize(deck)
          .copyWith(status: status)
          .serialize();
    });
  }

  @override
  Future<void> updateExercisedAt(Id id, DateTime exercisedAt) async {
    _assertExists(id);

    _decks.update(id, (deck) {
      return DeckModel
          .deserialize(deck)
          .copyWith(exercisedAt: exercisedAt)
          .serialize();
    });
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
  }

  /// Throws an exception if there's a deck with specified id in the database.
  void _assertNotExists(Id id) {
    if (_decks.containsKey(id)) {
      throw 'repository already contains deck [id=$id]';
    }
  }

  /// Throws an exception if there's no deck with specified id in the database.
  void _assertExists(Id id) {
    if (!_decks.containsKey(id)) {
      throw 'repository does not contain deck [id=$id]';
    }
  }
}
