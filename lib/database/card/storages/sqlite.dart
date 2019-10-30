import 'package:fiszker/database.dart';
import 'package:optional/optional.dart';

class SqliteCardStorage extends SqliteStorage implements CardStorage {
  SqliteCardStorage(DatabaseProvider databaseProvider) : super(databaseProvider);

  @override
  Future<void> add(CardModel card) async {
    await db.insert('cards', card.serialize());
  }

  Future<void> update(Id id, {
    Optional<Id> boxId = const Optional.empty(),
    Optional<String> front = const Optional.empty(),
    Optional<String> back = const Optional.empty(),
    Optional<Optional<DateTime>> exercisedAt = const Optional.empty(),
  }) async {
    final props = <String, dynamic>{};

    boxId.ifPresent((boxId) {
      props['boxId'] = boxId.serialize();
    });

    front.ifPresent((front) {
      props['front'] = front;
    });

    back.ifPresent((back) {
      props['back'] = back;
    });

    exercisedAt.ifPresent((exercisedAt) {
      props['exercisedAt'] = exercisedAt
          .map((date) => date.toIso8601String())
          .orElse(null);
    });

    if (props.isNotEmpty) {
      await db.update(
        'cards',
        props,
        where: 'id = ?',
        whereArgs: [id.toString()],
      );
    }
  }

  @override
  Future<List<CardModel>> findByDeckId(Id id) async {
    final cards = await db.query(
      'cards',
      where: 'deckId = ?',
      whereArgs: [id.serialize()],
    );

    return cards
        .map(CardModel.deserialize)
        .toList();
  }

  @override
  Future<void> remove(Id id) async {
    await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [id.serialize()],
    );
  }
}
