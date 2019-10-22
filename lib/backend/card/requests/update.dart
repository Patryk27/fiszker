import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

@immutable
class UpdateCardRequest {
  /// Id of the [CardModel] to update.
  final Id id;

  /// If present, the card front's text will be updated to specified value.
  final Optional<String> front;

  /// If present, the card back's text will be updated to specified value.
  final Optional<String> back;

  UpdateCardRequest({
    @required this.id,
    @required this.front,
    @required this.back,
  })
      : assert(id != null),
        assert(front != null),
        assert(back != null);

  /// Transforms given models into an [UpdateCardRequest].
  static UpdateCardRequest fromModels({
    @required CardModel oldCard,
    @required CardModel newCard,
  }) {
    return UpdateCardRequest(
      id: oldCard.id,

      front: (newCard.front == oldCard.front)
          ? Optional.empty()
          : Optional.of(newCard.front),

      back: (newCard.back == oldCard.back)
          ? Optional.empty()
          : Optional.of(newCard.back),
    );
  }
}
