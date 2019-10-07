import 'package:fiszker/backend.dart';

class InMemoryCardRepository implements CardRepository {
  final Map<Id, Map<String, dynamic>> _cards = {};

  @override
  Future<void> add(CardModel card) async {
    if (_cards.containsKey(card.id)) {
      throw 'repository already contains card [id=${card.id}]';
    }

    _cards[card.id] = card.serialize();
  }

  @override
  Future<void> updateFront(Id id, String front) async {
    _cards.update(id, (card) {
      return CardModel
          .deserialize(card)
          .copyWith(front: front)
          .serialize();
    });
  }

  @override
  Future<void> updateBack(Id id, String back) async {
    _cards.update(id, (card) {
      return CardModel
          .deserialize(card)
          .copyWith(back: back)
          .serialize();
    });
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
    _cards.remove(id);
  }
}
