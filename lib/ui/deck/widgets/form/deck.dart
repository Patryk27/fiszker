import 'package:fiszker/database.dart';
import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

import 'deck/name.dart';
import 'deck/status.dart';

/// This widget models the "Deck" section of the [DeckForm] widget.
class DeckFormDeckSection extends StatefulWidget {
  final DeckModel deck;
  final void Function(DeckModel deck) onDeckEdited;

  DeckFormDeckSection({
    @required this.deck,
    @required this.onDeckEdited,
  })
      : assert(deck != null),
        assert(onDeckEdited != null);

  @override
  State<DeckFormDeckSection> createState() => _DeckFormDeckSectionState();
}

class _DeckFormDeckSectionState extends State<DeckFormDeckSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TAB_VIEW_PADDING),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          DeckNameField(
            deck: widget.deck,
            onChanged: widget.onDeckEdited,
          ),

          const SizedBox(height: 15),

          DeckStatusField(
            deck: widget.deck,
            onChanged: widget.onDeckEdited,
          ),
        ],
      ),
    );
  }
}
