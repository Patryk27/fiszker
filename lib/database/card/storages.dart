import 'package:fiszker/database.dart';
import 'package:optional/optional.dart';

export 'storages/in_memory.dart';
export 'storages/sqlite.dart';

abstract class CardStorage {
  /// Adds given [CardModel] to the database.
  Future<void> add(CardModel card);

  /// Updates given [CardModel] in the database.
  Future<void> update(Id id, {
    Optional<Id> boxId = const Optional.empty(),
    Optional<String> front = const Optional.empty(),
    Optional<String> back = const Optional.empty(),
    Optional<Optional<DateTime>> exercisedAt = const Optional.empty(),
  });

  /// Returns all [CardModel]s that belong to given deck.
  Future<List<CardModel>> findByDeckId(Id id);

  /// Removes given [CardModel] from the database.
  Future<void> remove(Id id);
}
