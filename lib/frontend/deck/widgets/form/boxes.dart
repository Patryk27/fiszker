import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

/// This widgets models the "Boxes" section of the [DeckForm] widget.
class DeckFormBoxesSection extends StatefulWidget {
  final List<BoxModel> boxes;
  final List<CardModel> cards;
  final void Function() onCreateBox;
  final void Function(BoxModel box) onShowBox;

  DeckFormBoxesSection({
    @required this.boxes,
    @required this.cards,
    @required this.onCreateBox,
    @required this.onShowBox,
  })
      : assert(boxes != null),
        assert(cards != null),
        assert(onCreateBox != null),
        assert(onShowBox != null);

  @override
  _DeckFormBoxesSectionState createState() {
    return _DeckFormBoxesSectionState();
  }
}

class _DeckFormBoxesSectionState extends State<DeckFormBoxesSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.boxes.isEmpty) {
      return EmptyBoxList(
        onCreateBoxPressed: widget.onCreateBox,
      );
    }

    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TAB_VIEW_PADDING),

          child: BoxList(
            boxes: widget.boxes,
            cards: widget.cards,
            onBoxTapped: widget.onShowBox,
          ),
        ),
      ),
    );
  }
}
