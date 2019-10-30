import 'package:fiszker/database.dart';
import 'package:optional/optional.dart';

export 'storages/in_memory.dart';
export 'storages/sqlite.dart';

abstract class DeckStorage {
  /// Adds given [DeckModel] to the database.
  Future<void> add(DeckModel deck);

  /// Updates given [DeckModel] in the database.
  Future<void> update(Id id, {
    Optional<String> name = const Optional.empty(),
    Optional<DeckStatus> status = const Optional.empty(),
    Optional<Optional<DateTime>> exercisedAt = const Optional.empty(),
  });

  /// Returns the [DeckModel] with specified id, if one exists.
  Future<Optional<DeckModel>> findById(Id id);

  /// Returns all [DeckModel]s that match specified [status].
  Future<List<DeckModel>> findByStatus(DeckStatus status);

  /// Removes given [DeckModel] from the database.
  Future<void> remove(Id id);
}
