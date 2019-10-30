import 'package:fiszker/database.dart';
import 'package:optional/optional.dart';

export 'storages/in_memory.dart';
export 'storages/sqlite.dart';

abstract class BoxStorage {
  /// Adds given [BoxModel] to the database.
  Future<void> add(BoxModel box);

  /// Updates given [BoxModel] in the database.
  Future<void> update(Id id, {
    Optional<int> index = const Optional.empty(),
    Optional<String> name = const Optional.empty(),
    Optional<Optional<DateTime>> exercisedAt = const Optional.empty(),
  });

  /// Returns all [BoxModel]s that belong to specified deck.
  Future<List<BoxModel>> findByDeckId(Id id);

  /// Removes given [BoxModel] from the database.
  Future<void> remove(Id id);
}
