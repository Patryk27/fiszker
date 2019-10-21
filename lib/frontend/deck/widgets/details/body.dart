import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'body/detail.dart';

class DeckDetailsBody extends StatelessWidget {
  final DeckViewModel deck;

  DeckDetailsBody({
    @required this.deck,
  }) : assert(deck != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: DIALOG_PADDING,
        top: DIALOG_PADDING,
        right: DIALOG_PADDING,
        bottom: DIALOG_PADDING / 1.5,
      ),

      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            BottomSheetTitle(
              title: deck.deck.name,
            ),

            DeckDetail(
              title: 'Liczba fiszek:',
              value: deck.cards.length.toString(),
            ),

            const SizedBox(height: 20),

            DeckDetail(
              title: 'Utworzony:',
              value: timeago.format(deck.deck.createdAt),
            ),

            const SizedBox(height: 20),

            DeckDetail(
              title: 'Ostatnio ćwiczony:',
              value: deck.deck.exercisedAt.map(timeago.format).orElse('-'),
            ),
          ],
        ),
      ),
    );
  }
}
