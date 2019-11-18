import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

@immutable
class DeckEntity {
  final DeckModel deck;
  final List<BoxModel> boxes;
  final List<CardModel> cards;

  const DeckEntity({
    @required this.deck,
    @required this.boxes,
    @required this.cards,
  })
      : assert(deck != null),
        assert(boxes != null),
        assert(cards != null);

  static DeckEntity create({
    @required String name,
  }) {
    final deck = DeckModel.create(
      name: name,
    );

    return DeckEntity(
      deck: deck,

      boxes: [
        BoxModel.create(deckId: deck.id, index: 1, name: 'Nowe fiszki'),
        BoxModel.create(deckId: deck.id, index: 2, name: 'Powtarzaj codziennie'),
        BoxModel.create(deckId: deck.id, index: 3, name: 'Powtarzaj na począktu tygodnia'),
        BoxModel.create(deckId: deck.id, index: 4, name: 'Powtarzaj na początku miesiąca'),
        BoxModel.create(deckId: deck.id, index: 5, name: 'Nauczone fiszki'),
      ],

      cards: [],
    );
  }

  /// Returns a new [DeckEntity] overwritten with specified values.
  DeckEntity copyWith({
    DeckModel deck,
    List<BoxModel> boxes,
    List<CardModel> cards,
  }) {
    return DeckEntity(
      deck: deck ?? this.deck,
      boxes: boxes ?? this.boxes,
      cards: cards ?? this.cards,
    );
  }

  /// Returns a list of all the cards that belong to specified deck.
  List<CardModel> findCardsInsideBox(BoxModel box) {
    return cards
        .where((card) => card.belongsToBox(box))
        .toList();
  }

  /// Returns number of all the cards that belong to specified deck.
  int countCardsInsideBox(BoxModel box) {
    return findCardsInsideBox(box).length;
  }

  /// Returns a list of all the boxes that contain at least one card.
  List<BoxModel> findOccupiedBoxes() {
    return boxes
        .where((box) => countCardsInsideBox(box) > 0)
        .toList();
  }

  /// Returns predecessor of specified box, i.e.: such box that its index is `box.index - 1`.
  /// Returns nothing if no such box exists.
  Optional<BoxModel> findBoxPredecessor(BoxModel box) {
    for (final box2 in boxes) {
      if (box2.index == box.index - 1) {
        return Optional.of(box2);
      }
    }

    return Optional.empty();
  }

  /// Returns successor of specified box, i.e.: such box that its index is `box.index + 1`.
  /// Returns nothing if no such box exists.
  Optional<BoxModel> findBoxSuccessor(BoxModel box) {
    for (final box2 in boxes) {
      if (box2.index == box.index + 1) {
        return Optional.of(box2);
      }
    }

    return Optional.empty();
  }
}
