import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'body/card_side.dart';

class CardFormBody extends StatelessWidget {
  final CardModel card;
  final void Function(CardModel card) onChanged;

  CardFormBody({
    @required this.card,
    @required this.onChanged,
  })
      : assert(card != null),
        assert(onChanged != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Column(
        children: [
          CardSide(
            title: 'Awers fiszki',
            hint: 'np.: cztery ostatnie cyfry Pi',
            value: card.front,
            autofocus: card.front.isEmpty,

            onChanged: (front) {
              onChanged(card.copyWith(
                front: front,
              ));
            },
          ),

          const SizedBox(height: 15),

          CardSide(
            title: 'Rewers fiszki',
            hint: 'np.: 042',
            value: card.back,
            autofocus: false,

            onChanged: (back) {
              onChanged(card.copyWith(
                back: back,
              ));
            },
          ),
        ],
      ),
    );
  }
}
