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

  static String serialize(DeckStatus status) {
    return statuses[status];
  }

  static DeckStatus deserialize(String status) {
    return statuses.inverse[status];
  }
}
