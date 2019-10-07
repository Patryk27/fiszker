import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class SqliteDeckRepository extends SqliteRepository implements DeckRepository {
  SqliteDeckRepository({
    @required DatabaseProvider databaseProvider,
  }) : super(databaseProvider: databaseProvider);

  @override
  Future<void> add(DeckModel deck) async {
    await db.insert('decks', deck.serialize());
  }

  @override
  Future<void> updateName(Id id, String name) async {
    final idArg = id.serialize();

    await db.update(
      'decks',
      {'name': name},
      where: 'id = ?',
      whereArgs: [idArg],
    );
  }

  @override
  Future<void> updateStatus(Id id, DeckStatus status) async {
    final idArg = id.serialize();
    final statusArg = DeckStatusHelper.serialize(status);

    await db.update(
      'decks',
      {'status': statusArg},
      where: 'id = ?',
      whereArgs: [idArg],
    );
  }

  @override
  Future<void> updateExercisedAt(Id id, DateTime exercisedAt) async {
    final idArg = id.serialize();
    final exercisedAtArg = exercisedAt.toIso8601String();

    await db.update(
      'decks',
      {'exercisedAt': exercisedAtArg},
      where: 'id = ?',
      whereArgs: [idArg],
    );
  }

  @override
  Future<Optional<DeckModel>> findById(Id id) async {
    final idArg = id.serialize();

    final decks = await db.query(
      'decks',
      where: 'id = ?',
      whereArgs: [idArg],
    );

    return decks.isEmpty
        ? Optional.empty()
        : Optional.of(DeckModel.deserialize(decks.first));
  }

  @override
  Future<List<DeckModel>> findByStatus(DeckStatus status) async {
    final statusArg = DeckStatusHelper.serialize(status);

    final decks = await db.query(
      'decks',
      where: 'status = ?',
      whereArgs: [statusArg],
    );

    return decks
        .map(DeckModel.deserialize)
        .toList();
  }

  @override
  Future<void> remove(Id id) async {
    final idArg = id.serialize();

    await db.delete(
      'decks',
      where: 'id = ?',
      whereArgs: [idArg],
    );
  }
}
