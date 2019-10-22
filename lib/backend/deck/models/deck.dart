import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class DeckModel extends Model {
  /// Name of this deck.
  /// Doesn't have to be unique.
  final String name;

  /// Status of this deck.
  final DeckStatus status;

  /// When this deck was created.
  final DateTime createdAt;

  /// When this deck was exercised *for the last time*.
  /// May be empty, if this is a newly-created deck that hasn't been yet used.
  final Optional<DateTime> exercisedAt;

  const DeckModel({
    @required Id id,
    @required this.name,
    @required this.status,
    @required this.createdAt,
    @required this.exercisedAt,
  })
      : assert(name != null),
        assert(status != null),
        assert(createdAt != null),
        assert(exercisedAt != null),
        super(id: id);

  /// Creates a new, empty deck.
  DeckModel.create()
      : name = '',
        status = DeckStatus.active,
        createdAt = DateTime.now(),
        exercisedAt = Optional.empty(),
        super(id: Id.create());

  /// Returns a new [DeckModel] overwritten with specified values.
  DeckModel copyWith({
    Id id,
    String name,
    DeckStatus status,
    DateTime createdAt,
    DateTime exercisedAt,
  }) {
    return DeckModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      exercisedAt: exercisedAt ?? this.exercisedAt,
    );
  }

  /// Serializes this [DeckModel] into a list of its properties.
  Map<String, dynamic> serialize() {
    return {
      'id': id.serialize(),
      'name': name,
      'status': DeckStatusHelper.serialize(status),
      'createdAt': createdAt.toIso8601String(),

      'exercisedAt': exercisedAt
          .map((date) => date.toIso8601String())
          .orElse(null),
    };
  }

  /// Creates a new [DeckModel] from given list of its properties.
  static DeckModel deserialize(Map<String, dynamic> props) {
    return DeckModel(
      id: Id.deserialize(props['id']),
      name: props['name'],
      status: DeckStatusHelper.deserialize(props['status']),
      createdAt: DateTime.parse(props['createdAt']),

      exercisedAt: Optional
          .ofNullable(props['exercisedAt'])
          .map((date) => DateTime.parse(date)),
    );
  }

  /// Returns whether this [DeckModel] is the same as the other one (in terms of the contents).
  bool isEqualTo(DeckModel other) {
    return this.serialize().toString() == other.serialize().toString();
  }

  /// Returns whether this [DeckModel] is active.
  bool isActive() {
    return status == DeckStatus.active;
  }

  /// Returns whether this [DeckModel] has been archived.
  bool isArchived() {
    return status == DeckStatus.archived;
  }

  /// Returns whether this [DeckModel] has been completed.
  bool isCompleted() {
    return status == DeckStatus.completed;
  }
}
