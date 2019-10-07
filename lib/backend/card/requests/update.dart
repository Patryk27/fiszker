import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

@immutable
class UpdateCardRequest {
  final CardModel card;
  final Optional<String> front;
  final Optional<String> back;

  UpdateCardRequest({
    @required this.card,
    @required this.front,
    @required this.back,
  })
      : assert(card != null),
        assert(front != null),
        assert(back != null);

  static UpdateCardRequest build({
    @required CardModel oldCard,
    @required CardModel newCard,
  }) {
    return UpdateCardRequest(
      card: oldCard,
      front: (newCard.front == oldCard.front) ? Optional.empty() : Optional.of(newCard.front),
      back: (newCard.back == oldCard.back) ? Optional.empty() : Optional.of(newCard.back),
    );
  }
}
