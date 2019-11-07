import 'package:fiszker/domain.dart';
import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

import 'deck/name.dart';
import 'deck/status.dart';

/// This widget models the "Deck" section of the [DeckForm] widget.
class DeckFormSection extends StatefulWidget {
  final DeckEntity deck;

  DeckFormSection({
    @required this.deck,
  }) : assert(deck != null);

  @override
  State<DeckFormSection> createState() => _DeckFormSectionState();
}

class _DeckFormSectionState extends State<DeckFormSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(TAB_VIEW_PADDING),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          DeckNameField(
            deck: widget.deck.deck,
          ),

          const SizedBox(height: 15),

          DeckStatusField(
            deck: widget.deck.deck,
          ),
        ],
      ),
    );
  }
}
