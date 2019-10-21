import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

import 'cards/empty_list.dart';
import 'cards/populated_list.dart';
import 'cards/search_field.dart';

/// This widgets models the "Cards" section of the [DeckForm] widget.
class DeckFormCardsSection extends StatefulWidget {
  final List<CardModel> cards;
  final void Function() onCreateCardPressed;
  final void Function(CardModel card) onUpdateCardPressed;

  DeckFormCardsSection({
    @required this.cards,
    @required this.onCreateCardPressed,
    @required this.onUpdateCardPressed,
  })
      : assert(cards != null),
        assert(onCreateCardPressed != null),
        assert(onUpdateCardPressed != null);

  @override
  _DeckFormCardsSectionState createState() {
    return _DeckFormCardsSectionState();
  }
}

class _DeckFormCardsSectionState extends State<DeckFormCardsSection> with AutomaticKeepAliveClientMixin {
  String query = '';

  /// We want this widget kept alive, so that the filtering (i.e. the [query] property) is preserved whenever user moves
  /// through the form (e.g. when they switch to another tab and back here)
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // To be kept alive, we must call our superclass first
    super.build(context);

    if (widget.cards.isEmpty) {
      return CardEmptyList(
        onCallToAction: widget.onCreateCardPressed,
      );
    }

    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TAB_VIEW_PADDING),

          child: Column(
            children: [
              CardSearchField(
                onChanged: (newQuery) {
                  setState(() {
                    query = newQuery;
                  });
                },
              ),

              CardPopulatedList(
                cards: getCards(),

                onCardTapped: (card) {
                  widget.onUpdateCardPressed(card);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a filtered and sorted list of all the cards that will be displayed by this widget.
  List<CardModel> getCards() {
    var cards = widget.cards;

    if (query.isNotEmpty) {
      cards = cards
          .where((card) => card.front.contains(query) || card.back.contains(query))
          .toList();
    }

    cards.sort((a, b) {
      final frontCmp = a.front.compareTo(b.front);
      final backCmp = a.back.compareTo(b.back);

      if (frontCmp != 0) {
        return frontCmp;
      }

      if (backCmp != 0) {
        return backCmp;
      }

      return a.id.compareTo(b.id);
    });

    return cards;
  }
}
