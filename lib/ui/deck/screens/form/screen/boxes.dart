import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/theme.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

/// This widget models the "Boxes" section of the [DeckForm] widget.
class BoxesFormSection extends StatefulWidget {
  final DeckEntity deck;
  final void Function() onCreateBox;
  final void Function(BoxModel box) onEditBox;
  final void Function(BoxModel box, int newIndex) onMoveBox;

  BoxesFormSection({
    @required this.deck,
    @required this.onCreateBox,
    @required this.onEditBox,
    @required this.onMoveBox,
  })
      : assert(deck != null),
        assert(onCreateBox != null),
        assert(onEditBox != null),
        assert(onMoveBox != null);

  @override
  State<BoxesFormSection> createState() => _BoxesFormSectionState();
}

class _BoxesFormSectionState extends State<BoxesFormSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.deck.boxes.isEmpty) {
      return EmptyBoxList(
        onCreateBoxPressed: widget.onCreateBox,
      );
    }

    final boxes = List.of(widget.deck.boxes);

    // Sort boxes ascending by indexes
    boxes.sort((boxA, boxB) {
      return boxA.index.compareTo(boxB.index);
    });

    return Padding(
      padding: const EdgeInsets.all(TAB_VIEW_PADDING),

      child: BoxList(
        boxes: boxes,
        cards: widget.deck.cards,
        onBoxTapped: widget.onEditBox,
        onBoxMoved: widget.onMoveBox,
      ),
    );
  }
}
