import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class BoxModel extends Model {
  /// Id of the [DeckModel] this box belongs to.
  final Id deckId;

  /// An index of this box inside its deck.
  ///
  /// It's used to order the boxes appropriately, it's counted from `1` (meaning "the first box") and it's unique
  /// across an entire box.
  final int index;

  /// When this box was created.
  final DateTime createdAt;

  /// When this box was exercised at *for the last time*.
  /// May be empty, if this is a newly-created box that hasn't yet been used.
  final Optional<DateTime> exercisedAt;

  BoxModel({
    @required Id id,
    @required this.deckId,
    @required this.index,
    @required this.createdAt,
    @required this.exercisedAt,
  })
      : assert(deckId != null),
        assert(index != null),
        assert(createdAt != null),
        assert(exercisedAt != null),
        super(id: id);

  /// Creates a new, empty box.
  BoxModel.create({
    @required this.deckId,
    @required this.index,
  })
      : assert(deckId != null),
        assert(index != null && index > 0),
        createdAt = DateTime.now(),
        exercisedAt = Optional.empty(),
        super(id: Id.create());

  /// Returns a new [BoxModel] overwritten with specified values.
  BoxModel copyWith({
    Id id,
    Id deckId,
    int index,
    DateTime createdAt,
    Optional<DateTime> exercisedAt,
  }) {
    return BoxModel(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      index: index ?? this.index,
      createdAt: createdAt ?? this.createdAt,
      exercisedAt: exercisedAt ?? this.exercisedAt,
    );
  }

  /// Serializes this [BoxModel] into a list of its properties.
  Map<String, dynamic> serialize() {
    return {
      'id': id.serialize(),
      'deckId': deckId.serialize(),
      'index': index,
      'createdAt': createdAt.toIso8601String(),

      'exercisedAt': exercisedAt
          .map((date) => date.toIso8601String())
          .orElse(null),
    };
  }

  /// Creates a new [BoxModel] from given list of its properties.
  static BoxModel deserialize(Map<String, dynamic> props) {
    return BoxModel(
      id: Id.deserialize(props['id']),
      deckId: Id.deserialize(props['deckId']),
      index: props['index'],
      createdAt: DateTime.parse(props['createdAt']),

      exercisedAt: Optional
          .ofNullable(props['exercisedAt'])
          .map((date) => DateTime.parse(date)),
    );
  }

  /// Returns whether this [BoxModel] is the same as the other one (in terms of the contents).
  bool isEqualTo(BoxModel other) {
    return this.serialize().toString() == other.serialize().toString();
  }

  /// Returns box's human-readable title to use in lists and bottom sheets.
  String getTitle() {
    return 'Pudełko nr $index';
  }
}
