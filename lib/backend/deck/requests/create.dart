import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

@immutable
class CreateDeckRequest {
  final Id id;
  final String name;
  final List<CreateBoxRequest> boxes;
  final List<CreateCardRequest> cards;

  CreateDeckRequest({
    @required this.id,
    @required this.name,
    @required this.boxes,
    @required this.cards,
  })
      : assert(id != null),
        assert(name != null),
        assert(boxes != null),
        assert(cards != null);

  /// Transforms given models into a [CreateDeckRequest].
  static CreateDeckRequest fromModels({
    @required DeckModel deck,
    @required List<BoxModel> boxes,
    @required List<CardModel> cards,
  }) {
    return CreateDeckRequest(
      id: deck.id,
      name: deck.name,

      boxes: boxes
          .map((box) => CreateBoxRequest.fromModel(box: box))
          .toList(),

      cards: cards
          .map((card) => CreateCardRequest.fromModel(card: card))
          .toList(),
    );
  }
}
