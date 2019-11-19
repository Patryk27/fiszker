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
    final deck = DeckModel.create(name: name);

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

  /// Changes this deck's name and returns the changed deck's instance.
  DeckEntity changeName(String newName) {
    return _copyWith(
      deck: deck.copyWith(name: newName),
    );
  }

  /// Changes this deck's status and returns the changed deck's instance.
  DeckEntity changeStatus(DeckStatus newStatus) {
    return _copyWith(
      deck: deck.copyWith(status: newStatus),
    );
  }

  /// Adds a new box to the end of this deck and returns the changed deck's instance.
  DeckEntity createBox(String name) {
    final newBox = BoxModel.create(
      deckId: deck.id,
      index: boxes.length + 1,
      name: name,
    );

    final newBoxes = List.of(boxes)
      ..add(newBox);

    return _copyWith(boxes: newBoxes);
  }

  /// Moves specified box to a new index (1-indexed) and returns the changed deck's instance.
  DeckEntity moveBox(BoxModel box, int newIndex) {
    final newBoxes = boxes.map((box2) {
      if (box2.id == box.id) {
        return box2.copyWith(index: newIndex);
      }

      if (newIndex < box.index) {
        if (box2.index >= newIndex && box2.index < box.index) {
          return box2.copyWith(index: box2.index + 1);
        }
      } else {
        if (box2.index > box.index && box2.index <= newIndex) {
          return box2.copyWith(index: box2.index - 1);
        }
      }

      return box2;
    }).toList();

    return _copyWith(boxes: newBoxes);
  }

  /// Updates specified box in this deck and returns the changed deck's instance.
  DeckEntity updateBox(BoxModel box, { String newName }) {
    final newBoxes = boxes.map((box2) {
      if (box2.id == box.id) {
        return box.copyWith(name: newName);
      } else {
        return box2;
      }
    }).toList();

    return _copyWith(boxes: newBoxes);
  }

  /// Removes specified box from this deck and returns the changed deck's instance.
  DeckEntity deleteBox(BoxModel box) {
    // Since we're deleting a box, we have to decide what happens to all the cards that are currently located inside
    // it - they should be moved either to the next box or to the previous one:
    final boxSuccessor = findBoxSuccessor(box);
    final boxPredecessor = findBoxPredecessor(box);

    final targetBox = boxSuccessor.isPresent
        ? boxSuccessor.value
        : boxPredecessor.value;

    // Now we have to relocate cards to the target box
    final newCards = cards.map((card) {
      if (card.belongsToBox(box)) {
        return card.copyWith(boxId: targetBox.id);
      } else {
        return card;
      }
    }).toList();

    // At this point we can safely delete the box...
    var newBoxes = List.of(boxes)
      ..removeWhere((box2) => box2.id == box.id);

    // ... and reindex the old ones, so we don't end up with a hole in our enumeration
    newBoxes = newBoxes.map((box2) {
      if (box2.index >= box.index) {
        return box2.copyWith(index: box2.index - 1);
      } else {
        return box2;
      }
    }).toList();

    return _copyWith(boxes: newBoxes, cards: newCards);
  }

  /// Adds a new card to this deck and returns the changed deck's instance.
  DeckEntity createCard(Id boxId, String front, String back) {
    final newCard = CardModel.create(
      deckId: deck.id,
      boxId: boxId,
      front: front,
      back: back,
    );

    final newCards = List.of(cards)
      ..add(newCard);

    return _copyWith(cards: newCards);
  }

  /// Updates specified card in this deck and returns the changed deck's instance.
  DeckEntity updateCard(CardModel card, {
    String newFront,
    String newBack,
  }) {
    final newCards = cards.map((card2) {
      if (card2.id == card.id) {
        return card2.copyWith(
          front: newFront,
          back: newBack,
        );
      } else {
        return card2;
      }
    }).toList();

    return _copyWith(cards: newCards);
  }

  /// Removes specified card from this deck and returns the changed deck's instance.
  DeckEntity deleteCard(CardModel card) {
    final newCards = cards
        .where((card2) => card2.id != card.id)
        .toList();

    return _copyWith(cards: newCards);
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

    return const Optional.empty();
  }

  /// Returns successor of specified box, i.e.: such box that its index is `box.index + 1`.
  /// Returns nothing if no such box exists.
  Optional<BoxModel> findBoxSuccessor(BoxModel box) {
    for (final box2 in boxes) {
      if (box2.index == box.index + 1) {
        return Optional.of(box2);
      }
    }

    return const Optional.empty();
  }

  /// Returns a new [DeckEntity] overwritten with specified values.
  /// It's private, because users should use dedicated methods like [changeName].
  DeckEntity _copyWith({
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
}
