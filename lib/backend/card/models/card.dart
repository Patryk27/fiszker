import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

class CardModel extends Model {
  final Id deckId;
  final String front;
  final String back;
  final DateTime createdAt;

  const CardModel({
    @required Id id,
    @required this.deckId,
    @required this.front,
    @required this.back,
    @required this.createdAt,
  })
      : assert(deckId != null),
        assert(front != null),
        assert(back != null),
        assert(createdAt != null),
        super(id: id);

  /// Creates a new, empty card.
  CardModel.create({
    @required this.deckId,
  })
      : assert(deckId != null),
        front = '',
        back = '',
        createdAt = DateTime.now(),
        super(id: Id.create());

  /// Returns a new [CardModel] overwritten with specified values.
  CardModel copyWith({
    Id id,
    Id deckId,
    String front,
    String back,
    DateTime createdAt,
  }) {
    return CardModel(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Serializes this [CardModel] into a list of its properties.
  Map<String, dynamic> serialize() {
    return {
      'id': id.serialize(),
      'deckId': deckId.serialize(),
      'front': front,
      'back': back,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Creates a new [CardModel] from given list of its properties.
  static CardModel deserialize(Map<String, dynamic> props) {
    return CardModel(
      id: Id.deserialize(props['id']),
      deckId: Id.deserialize(props['deckId']),
      front: props['front'],
      back: props['back'],
      createdAt: DateTime.parse(props['createdAt']),
    );
  }

  /// Returns whether this [CardModel] is the same as the other one (in terms of the contents).
  bool isEqualTo(CardModel other) {
    return this.serialize().toString() == other.serialize().toString();
  }
}
