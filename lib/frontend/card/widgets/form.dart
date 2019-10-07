import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

import 'form/actions.dart';
import 'form/body.dart';
import 'form/title.dart';

enum CardFormBehavior {
  createCard,
  updateCard,
}

/// This widgets models a [Dialog] responsible for creating and managing deck's cards.
///
/// It does not touch the database on its own, you have to provide meaningful handlers for the [onSubmit] and
/// [onDelete] events.
class CardForm extends StatefulWidget {
  final CardFormBehavior formBehavior;
  final CardModel card;
  final void Function(CardModel card) onSubmit;
  final void Function(CardModel card) onDelete;

  /// Returns "Create a new flashcard" form.
  CardForm.createCard({
    Id deckId,
    @required this.onSubmit,
  })
      : formBehavior = CardFormBehavior.createCard,
        card = CardModel.create(deckId: deckId),
        assert(onSubmit != null),
        onDelete = null;

  /// Returns "Edit this flashcard" form.
  CardForm.updateCard({
    @required this.card,
    @required this.onSubmit,
    @required this.onDelete,
  })
      : formBehavior = CardFormBehavior.updateCard,
        assert(card != null),
        assert(onSubmit != null),
        assert(onDelete != null);

  @override
  _CardFormState createState() {
    return _CardFormState(card);
  }
}

class _CardFormState extends State<CardForm> {
  _CardFormState(this.card);

  CardModel card;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,

      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
          CardFormTitle(
            formBehavior: widget.formBehavior,
            card: card,
          ),

          Form(
            key: formKey,

            child: CardFormBody(
              card: card,

              onChanged: (card) {
                setState(() {
                  this.card = card;
                });
              },
            ),
          ),

          CardFormActions(
            formBehavior: widget.formBehavior,
            card: card,

            onSubmit: () {
              if (formKey.currentState.validate()) {
                widget.onSubmit(card);
                Navigator.pop(context);
              }
            },

            onDelete: () {
              widget.onDelete(card);
              Navigator.pop(context);
            },

            onDismiss: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
