import 'package:fiszker/database.dart';
import 'package:optional/optional_internal.dart';

class SqliteBoxStorage extends SqliteStorage implements BoxStorage {
  SqliteBoxStorage(DatabaseProvider databaseProvider) : super(databaseProvider);

  @override
  Future<void> add(BoxModel box) async {
    await db.insert('boxes', box.serialize());
  }

  @override
  Future<void> update(Id id, {
    Optional<int> index = const Optional.empty(),
    Optional<String> name = const Optional.empty(),
    Optional<Optional<DateTime>> exercisedAt = const Optional.empty(),
  }) async {
    final props = <String, dynamic>{};

    index.ifPresent((index) {
      props['index'] = index;
    });

    name.ifPresent((name) {
      props['name'] = name;
    });

    exercisedAt.ifPresent((exercisedAt) {
      props['exercisedAt'] = exercisedAt
          .map((date) => date.toIso8601String())
          .orElse(null);
    });

    if (props.isNotEmpty) {
      await db.update(
        'boxes',
        props,
        where: 'id = ?',
        whereArgs: [id.toString()],
      );
    }
  }

  @override
  Future<List<BoxModel>> findByDeckId(Id id) async {
    final boxes = await db.query(
      'boxes',
      where: 'deckId = ?',
      whereArgs: [id.serialize()],
    );

    return boxes
        .map(BoxModel.deserialize)
        .toList();
  }

  @override
  Future<void> remove(Id id) async {
    await db.delete(
      'boxes',
      where: 'id = ?',
      whereArgs: [id.serialize()],
    );
  }
}
