import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

class SqliteCardRepository extends SqliteRepository implements CardRepository {
  SqliteCardRepository({
    @required DatabaseProvider databaseProvider,
  }) : super(databaseProvider: databaseProvider);

  @override
  Future<void> add(CardModel card) async {
    await db.insert('cards', card.serialize());
  }

  @override
  Future<List<CardModel>> findByDeckId(Id id) async {
    final idArg = id.serialize();

    final cards = await db.query(
      'cards',
      where: 'deckId = ?',
      whereArgs: [idArg],
    );

    return cards
        .map(CardModel.deserialize)
        .toList();
  }

  @override
  Future<void> updateBack(Id id, String back) async {
    final idArg = id.serialize();

    await db.update(
      'cards',
      {'back': back},
      where: 'id = ?',
      whereArgs: [idArg],
    );
  }

  @override
  Future<void> updateFront(Id id, String front) async {
    final idArg = id.serialize();

    await db.update(
      'cards',
      {'front': front},
      where: 'id = ?',
      whereArgs: [idArg],
    );
  }

  @override
  Future<void> remove(Id id) async {
    final idArg = id.serialize();

    await db.delete(
      'cards',
      where: 'id = ?',
      whereArgs: [idArg],
    );
  }
}
