import 'package:quiver/collection.dart';

enum DeckStatus {
  active,
  archived,
  completed,
}

class DeckStatusHelper {
  static final statuses = BiMap()
    ..addAll({
      DeckStatus.active: 'active',
      DeckStatus.archived: 'archived',
      DeckStatus.completed: 'completed',
    });

  /// Serializes given [DeckStatus] into a string.
  static String serialize(DeckStatus status) => statuses[status];

  /// Deserializes given string back into a [DeckStatus].
  static DeckStatus deserialize(String status) => statuses.inverse[status];
}
