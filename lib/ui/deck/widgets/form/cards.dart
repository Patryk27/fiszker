import 'package:fiszker/database.dart';
import 'package:fiszker/theme.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import 'cards/filter.dart';

/// This widget models the "Cards" section of the [DeckForm] widget.
class DeckFormCardsSection extends StatelessWidget {
  /// List of all the deck's cards.
  final List<CardModel> cards;

  /// List of all the deck's boxes.
  /// Used to filter cards when user requests so.
  final List<BoxModel> boxes;

  /// Controller for the searcher's text input.
  final TextEditingController queryController;

  /// Handler for the "create card" button.
  final void Function() onCreateCard;

  /// Handler for the "edit card" button.
  final void Function(CardModel card) onEditCard;

  DeckFormCardsSection({
    @required this.cards,
    @required this.boxes,
    @required this.queryController,
    @required this.onCreateCard,
    @required this.onEditCard,
  })
      : assert(cards != null),
        assert(boxes != null),
        assert(queryController != null),
        assert(onCreateCard != null),
        assert(onEditCard != null);

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return EmptyCardList(
        onCreateCardPressed: onCreateCard,
      );
    }

    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TAB_VIEW_PADDING),

          child: Column(
            children: [
              CardListSearcher(
                controller: queryController,
              ),

              CardList(
                cards: filterCards(
                  cards: cards,
                  boxes: boxes,
                  query: queryController.text.trim(),
                ),

                onCardTapped: onEditCard,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
