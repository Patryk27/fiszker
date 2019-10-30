import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';

import 'list/item.dart';

class BoxList extends StatelessWidget {
  /// List of boxes to display.
  final List<BoxModel> boxes;

  /// List of cards (used to count number of cards inside each box).
  final List<CardModel> cards;

  /// Fired when user taps on a box - can be used to open the box's form.
  final void Function(BoxModel box) onBoxTapped;

  /// Fired when user re-orders box inside the list.
  final void Function(BoxModel box, int newIndex) onBoxMoved;

  BoxList({
    @required this.boxes,
    @required this.cards,
    @required this.onBoxTapped,
    @required this.onBoxMoved,
  })
      : assert(boxes != null),
        assert(cards != null),
        assert(onBoxTapped != null),
        assert(onBoxMoved != null);

  @override
  Widget build(BuildContext context) {
    final children = boxes.map((box) {
      return BoxListItem(
        box: box,
        boxCardCount: countCardsInsideBox(box),

        onTapped: () {
          onBoxTapped(box);
        },
      );
    }).toList();

    return ReorderableListView(
      children: children,

      onReorder: (oldIndex, newIndex) {
        onBoxMoved(
          children[oldIndex].box,
          (newIndex < oldIndex) ? (newIndex + 1) : newIndex,
        );
      },
    );
  }

  /// Returns number of cards that are bound to given box.
  int countCardsInsideBox(BoxModel box) {
    return cards.fold(0, (result, card) {
      if (card.belongsToBox(box)) {
        result += 1;
      }

      return result;
    });
  }
}
