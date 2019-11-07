import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/theme.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import 'cards/filter.dart';

/// This widget models the "Cards" section of the [DeckForm] widget.
class CardsFormSection extends StatelessWidget {
  final DeckEntity deck;

  /// Controller for the searcher's text input.
  final TextEditingController queryController;

  /// Handler for the "create card" button.
  final void Function() onCreateCard;

  /// Handler for the "edit card" button.
  final void Function(CardModel card) onEditCard;

  CardsFormSection({
    @required this.deck,
    @required this.queryController,
    @required this.onCreateCard,
    @required this.onEditCard,
  })
      : assert(deck != null),
        assert(queryController != null),
        assert(onCreateCard != null),
        assert(onEditCard != null);

  @override
  Widget build(BuildContext context) {
    if (deck.cards.isEmpty) {
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
                  cards: deck.cards,
                  boxes: deck.boxes,
                  query: queryController.text.trim(),
                ),

                onCardTapped: onEditCard,
              ),

              const SizedBox(height: 5),

              RaisedButton(
                onPressed: onCreateCard,
                child: const Text('DODAJ NASTĘPNĄ FISZKĘ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
