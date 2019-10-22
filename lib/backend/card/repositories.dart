import 'package:fiszker/backend.dart';

export 'repositories/in_memory.dart';
export 'repositories/sqlite.dart';

abstract class CardRepository {
  /// Adds given [CardModel] to the database.
  Future<void> add(CardModel card);

  /// Updates the [CardModel.front] property of given card.
  Future<void> updateFront(Id id, String front);

  /// Updates the [CardModel.back] property of given card.
  Future<void> updateBack(Id id, String back);

  /// Returns all [CardModel]s that belong to specified deck.
  Future<List<CardModel>> findByDeckId(Id id);

  /// Removes given [CardModel] from the database.
  Future<void> remove(Id id);
}
