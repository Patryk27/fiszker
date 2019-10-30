import 'package:fiszker/database.dart';
import 'package:optional/optional.dart';

class SqliteDeckStorage extends SqliteStorage implements DeckStorage {
  SqliteDeckStorage(DatabaseProvider databaseProvider) : super(databaseProvider);

  @override
  Future<void> add(DeckModel deck) async {
    await db.insert('decks', deck.serialize());
  }

  Future<void> update(Id id, {
    Optional<String> name = const Optional.empty(),
    Optional<DeckStatus> status = const Optional.empty(),
    Optional<Optional<DateTime>> exercisedAt = const Optional.empty(),
  }) async {
    final props = <String, dynamic>{};

    name.ifPresent((name) {
      props['name'] = name;
    });

    status.ifPresent((status) {
      props['status'] = status;
    });

    exercisedAt.ifPresent((exercisedAt) {
      props['exercisedAt'] = exercisedAt
          .map((date) => date.toIso8601String())
          .orElse(null);
    });

    if (props.isNotEmpty) {
      await db.update(
        'decks',
        props,
        where: 'id = ?',
        whereArgs: [id.toString()],
      );
    }
  }

  @override
  Future<Optional<DeckModel>> findById(Id id) async {
    final decks = await db.query(
      'decks',
      where: 'id = ?',
      whereArgs: [id.serialize()],
    );

    return decks.isEmpty
        ? const Optional.empty()
        : Optional.of(DeckModel.deserialize(decks.first));
  }

  @override
  Future<List<DeckModel>> findByStatus(DeckStatus status) async {
    final decks = await db.query(
      'decks',
      where: 'status = ?',
      whereArgs: [DeckStatusHelper.serialize(status)],
    );

    return decks
        .map(DeckModel.deserialize)
        .toList();
  }

  @override
  Future<void> remove(Id id) async {
    await db.delete(
      'decks',
      where: 'id = ?',
      whereArgs: [id.serialize()],
    );
  }
}
