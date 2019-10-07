import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.cards.isEmpty) {
      return CardEmptyList(
        onCallToAction: widget.onCreateCardPressed,
      );
    }

    final form = Column(
      children: [
        CardSearchField(
          onChanged: (newQuery) {
            setState(() {
              query = newQuery;
            });
          },
        ),

        Expanded(
          child: CardPopulatedList(
            cards: getCards(),

            onCardTapped: (card) {
              widget.onUpdateCardPressed(card);
            },
          ),
        ),
      ],
    );

    return form;
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
