import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'body/card_side.dart';

class CardFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final CardModel card;
  final void Function(CardModel card) onChanged;

  CardFormBody({
    @required this.formKey,
    @required this.card,
    @required this.onChanged,
  })
      : assert(formKey != null),
        assert(card != null),
        assert(onChanged != null);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      child: Column(
        children: [
          CardSide(
            title: 'Treść awersu',
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
            title: 'Treść rewersu',
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
