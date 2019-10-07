import 'package:fiszker/backend.dart';
import 'package:optional/optional.dart';

export 'repositories/in_memory.dart';
export 'repositories/sqlite.dart';

abstract class DeckRepository {
  /// Adds given [deck] to the database.
  Future<void> add(DeckModel deck);

  /// Updates the [DeckModel.name] property of given deck.
  Future<void> updateName(Id id, String name);

  /// Updates the [DeckModel.status] property of given deck.
  Future<void> updateStatus(Id id, DeckStatus status);

  /// Updates the [DeckModel.exercisedAt] property of given deck.
  Future<void> updateExercisedAt(Id id, DateTime exercisedAt);

  /// Returns the [DeckModel] with specified id, if one exists.
  Future<Optional<DeckModel>> findById(Id id);

  /// Returns all [DeckModel]s that match specified [status].
  Future<List<DeckModel>> findByStatus(DeckStatus status);

  /// Removes given [DeckModel] from the database.
  Future<void> remove(Id id);
}
