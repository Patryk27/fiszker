import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

@immutable
class CreateCardRequest {
  final Id id;
  final Id deckId;
  final Id boxId;
  final String front;
  final String back;

  CreateCardRequest({
    @required this.id,
    @required this.deckId,
    @required this.boxId,
    @required this.front,
    @required this.back,
  })
      : assert(id != null),
        assert(deckId != null),
        assert(boxId != null),
        assert(front != null),
        assert(back != null);

  /// Transforms given [CardModel] into a [CreateCardRequest].
  static CreateCardRequest fromModel({
    @required CardModel card,
  }) {
    return CreateCardRequest(
      id: card.id,
      deckId: card.deckId,
      boxId: card.boxId,
      front: card.front,
      back: card.back,
    );
  }
}
