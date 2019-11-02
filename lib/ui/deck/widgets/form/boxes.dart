import 'package:fiszker/database.dart';
import 'package:fiszker/theme.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

/// This widget models the "Boxes" section of the [DeckForm] widget.
class DeckFormBoxesSection extends StatefulWidget {
  final List<BoxModel> boxes;
  final List<CardModel> cards;
  final void Function() onCreateBox;
  final void Function(BoxModel box) onShowBox;
  final void Function(BoxModel box, int newIndex) onMoveBox;

  DeckFormBoxesSection({
    @required this.boxes,
    @required this.cards,
    @required this.onCreateBox,
    @required this.onShowBox,
    @required this.onMoveBox,
  })
      : assert(boxes != null),
        assert(cards != null),
        assert(onCreateBox != null),
        assert(onShowBox != null),
        assert(onMoveBox != null);

  @override
  State<DeckFormBoxesSection> createState() => _DeckFormBoxesSectionState();
}

class _DeckFormBoxesSectionState extends State<DeckFormBoxesSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.boxes.isEmpty) {
      return EmptyBoxList(
        onCreateBoxPressed: widget.onCreateBox,
      );
    }

    final boxes = List.of(widget.boxes);

    // Sort boxes ascending by indexes
    boxes.sort((boxA, boxB) {
      return boxA.index.compareTo(boxB.index);
    });

    return Padding(
      padding: const EdgeInsets.all(TAB_VIEW_PADDING),

      child: BoxList(
        boxes: boxes,
        cards: widget.cards,
        onBoxTapped: widget.onShowBox,
        onBoxMoved: widget.onMoveBox,
      ),
    );
  }
}
