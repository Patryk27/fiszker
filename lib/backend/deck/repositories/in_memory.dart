import 'package:fiszker/backend.dart';
import 'package:optional/optional.dart';

class InMemoryDeckRepository implements DeckRepository {
  final Map<Id, Map<String, dynamic>> _decks = {};

  @override
  Future<void> add(DeckModel deck) async {
    if (_decks.containsKey(deck.id)) {
      throw 'repository already contains deck [id=${deck.id}]';
    }

    _decks[deck.id] = deck.serialize();
  }

  @override
  Future<void> updateName(Id id, String name) async {
    _decks.update(id, (deck) {
      return DeckModel
          .deserialize(deck)
          .copyWith(name: name)
          .serialize();
    });
  }

  @override
  Future<void> updateStatus(Id id, DeckStatus status) async {
    _decks.update(id, (deck) {
      return DeckModel
          .deserialize(deck)
          .copyWith(status: status)
          .serialize();
    });
  }

  @override
  Future<void> updateExercisedAt(Id id, DateTime exercisedAt) async {
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
    _decks.remove(id);
  }
}
