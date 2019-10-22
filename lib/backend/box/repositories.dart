import 'package:fiszker/backend.dart';

export 'repositories/in_memory.dart';

abstract class BoxRepository {
  /// Adds given [BoxModel] to the database.
  Future<void> add(BoxModel box);

  /// Returns all [BoxModel]s that belong to specified deck.
  Future<List<BoxModel>> findByDeckId(Id id);

  /// Removes given [BoxModel] from the database.
  Future<void> remove(Id id);
}
