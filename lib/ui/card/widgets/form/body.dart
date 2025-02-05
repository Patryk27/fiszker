import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';

import 'body/box_field.dart';
import 'body/side_field.dart';

class CardFormBody extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final DeckEntity deck;
  final CardModel card;
  final void Function(CardModel card) onChanged;

  CardFormBody({
    @required this.formKey,
    @required this.deck,
    @required this.card,
    @required this.onChanged,
  })
      : assert(formKey != null),
        assert(deck != null),
        assert(card != null),
        assert(onChanged != null);

  @override
  State<StatefulWidget> createState() => _CardFormBodyState();
}

class _CardFormBodyState extends State<CardFormBody> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,

      child: Column(
        children: [
          // Card's front
          CardSideField(
            title: 'Treść awersu',
            hint: 'np.: dwie ostatnie cyfry Pi',
            value: widget.card.front,
            autofocus: widget.card.front.isEmpty,

            onChanged: (front) {
              widget.onChanged(widget.card.copyWith(
                front: front,
              ));
            },
          ),

          const SizedBox(height: 15),

          // Card's back
          CardSideField(
            title: 'Treść rewersu',
            hint: 'np.: 42',
            value: widget.card.back,
            autofocus: false,

            onChanged: (back) {
              widget.onChanged(widget.card.copyWith(
                back: back,
              ));
            },
          ),

          const SizedBox(height: 15),

          // Card's box
          CardBoxField(
            boxes: widget.deck.boxes,
            value: widget.card.boxId,

            onChanged: (boxId) {
              widget.onChanged(widget.card.copyWith(
                boxId: boxId,
              ));
            },
          ),
        ],
      ),
    );
  }
}
