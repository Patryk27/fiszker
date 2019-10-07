import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

@immutable
class CreateCardRequest {
  final Id deckId;
  final String front;
  final String back;

  CreateCardRequest({
    @required this.deckId,
    @required this.front,
    @required this.back,
  })
      : assert(deckId != null),
        assert(front != null),
        assert(back != null);

  static CreateCardRequest build({
    @required Id deckId,
    @required CardModel card,
  }) {
    return CreateCardRequest(
      deckId: deckId,
      front: card.front,
      back: card.back,
    );
  }
}
