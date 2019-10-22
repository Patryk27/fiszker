import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'list/item.dart';

class BoxList extends StatelessWidget {
  /// List of boxes to display.
  final List<BoxModel> boxes;

  /// List of cards (used to count how many cards each box has).
  final List<CardModel> cards;

  /// Fired when user taps on a box - can be used to open the box's bottom sheet.
  final void Function(BoxModel box) onBoxTapped;

  BoxList({
    @required this.boxes,
    @required this.cards,
    @required this.onBoxTapped,
  })
      : assert(boxes != null),
        assert(cards != null),
        assert(onBoxTapped != null);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: boxes.length,

      itemBuilder: (context, index) {
        final box = boxes[index];

        return BoxListItem(
          box: box,
          boxCardCount: countCardsInsideBox(box),

          onTapped: () {
            onBoxTapped(box);
          },
        );
      },
    );
  }

  /// Returns number of cards that are bound to given box.
  int countCardsInsideBox(BoxModel box) {
    return cards.fold(0, (result, card) {
      if (card.boxId == box.id) {
        result += 1;
      }

      return result;
    });
  }
}
