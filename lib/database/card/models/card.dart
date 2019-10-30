import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class CardModel extends Model {
  /// Id of the [DeckModel] this card belongs to.
  ///
  /// This field is *technically unnecessary* (since we can pivot-know it using [boxId]), but it greatly simplifies the
  /// design, so it's here to stay.
  final Id deckId;

  /// Id of the [BoxModel] this card belongs to.
  /// The box's deck id should be the same as ours, otherwise wild things may happen.
  final Id boxId;

  /// Text on the front of the card.
  final String front;

  /// Text on the back of the card.
  final String back;

  /// When this card was created.
  final DateTime createdAt;

  /// When this card was exercised *for the last time*.
  /// May be empty, if this is a newly-created deck that hasn't been used yet.
  final Optional<DateTime> exercisedAt;

  const CardModel({
    @required Id id,
    @required this.deckId,
    @required this.boxId,
    @required this.front,
    @required this.back,
    @required this.createdAt,
    @required this.exercisedAt,
  })
      : assert(deckId != null),
        assert(boxId != null),
        assert(front != null),
        assert(back != null),
        assert(createdAt != null),
        assert(exercisedAt != null),
        super(id: id);

  /// Creates a new, empty card.
  CardModel.create({
    @required this.deckId,
    @required this.boxId,
  })
      : assert(deckId != null),
        assert(boxId != null),
        front = '',
        back = '',
        createdAt = DateTime.now(),
        exercisedAt = Optional.empty(),
        super(id: Id.create());

  /// Returns a new [CardModel] overwritten with specified values.
  CardModel copyWith({
    Id id,
    Id deckId,
    Id boxId,
    String front,
    String back,
    DateTime createdAt,
    Optional<DateTime> exercisedAt,
  }) {
    return CardModel(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      boxId: boxId ?? this.boxId,
      front: front ?? this.front,
      back: back ?? this.back,
      createdAt: createdAt ?? this.createdAt,
      exercisedAt: exercisedAt ?? this.exercisedAt,
    );
  }

  /// Serializes this [CardModel] into a list of its properties.
  Map<String, dynamic> serialize() {
    return {
      'id': id.serialize(),
      'deckId': deckId.serialize(),
      'boxId': boxId.serialize(),
      'front': front,
      'back': back,
      'createdAt': createdAt.toIso8601String(),
      'exercisedAt': exercisedAt.map((date) => date.toIso8601String()).orElse(null),
    };
  }

  /// Creates a new [CardModel] from given list of its properties.
  static CardModel deserialize(Map<String, dynamic> props) {
    return CardModel(
      id: Id.deserialize(props['id']),
      deckId: Id.deserialize(props['deckId']),
      boxId: Id.deserialize(props['boxId']),
      front: props['front'].toString(),
      back: props['back'].toString(),
      createdAt: DateTime.parse(props['createdAt']),
      exercisedAt: Optional.ofNullable(props['exercisedAt']).map((date) => DateTime.parse(date)),
    );
  }

  /// Returns whether this [CardModel] belongs to specified [BoxModel].
  bool belongsToBox(BoxModel box) => boxId == box.id;
}
