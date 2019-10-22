import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'body/box_field.dart';
import 'body/side_field.dart';

class CardFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<BoxModel> boxes;
  final CardModel card;
  final void Function(CardModel card) onChanged;

  CardFormBody({
    @required this.formKey,
    @required this.boxes,
    @required this.card,
    @required this.onChanged,
  })
      : assert(formKey != null),
        assert(boxes != null),
        assert(card != null),
        assert(onChanged != null);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,

      child: Column(
        children: [
          // Card's front
          CardSideField(
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

          // Card's back
          CardSideField(
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

          const SizedBox(height: 15),

          // Card's box
          CardBoxField(
            boxes: boxes,
            value: card.boxId,

            onChanged: (boxId) {
              onChanged(card.copyWith(
                boxId: boxId,
              ));
            },
          ),
        ],
      ),
    );
  }
}
