import 'package:fiszker/database.dart';
import 'package:optional/optional.dart';

class InMemoryCardsStorage implements CardStorage {
  final Map<Id, Map<String, dynamic>> _cards = {};

  @override
  Future<void> add(CardModel card) async {
    _assertNotExists(card.id);
    _cards[card.id] = card.serialize();

    print('(db) Card added: $card');
  }

  Future<void> update(Id id, {
    Optional<Id> boxId = const Optional.empty(),
    Optional<String> front = const Optional.empty(),
    Optional<String> back = const Optional.empty(),
    Optional<Optional<DateTime>> exercisedAt = const Optional.empty(),
  }) async {
    _assertExists(id);

    _cards.update(id, (card) {
      return CardModel.deserialize(card).copyWith(
        boxId: boxId.orElse(null),
        front: front.orElse(null),
        back: back.orElse(null),
        exercisedAt: exercisedAt.orElse(null),
      ).serialize();
    });

    print('(db) Card updated: id=$id, boxId=$boxId, front=$front, back=$back, exercisedAt=$exercisedAt');
  }

  @override
  Future<List<CardModel>> findByDeckId(Id id) async {
    return _cards.values
        .map(CardModel.deserialize)
        .where((card) => card.deckId == id)
        .toList();
  }

  @override
  Future<void> remove(Id id) async {
    _assertExists(id);
    _cards.remove(id);

    print('(db) Card removed: id=$id');
  }

  void _assertNotExists(Id id) {
    if (_cards.containsKey(id)) {
      throw 'storage already contains card [id=$id]';
    }
  }

  void _assertExists(Id id) {
    if (!_cards.containsKey(id)) {
      throw 'storage does not contain card [id=$id]';
    }
  }
}
