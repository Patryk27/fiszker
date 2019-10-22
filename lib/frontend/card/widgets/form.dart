import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart' as frontend;
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import 'form/body.dart';

/// Defines how the [CardForm] should act as - that is: whether it's supposed to be "Create a flashcard" or "Edit a
/// flashcard" variant.
enum CardFormBehavior {
  createCard,
  editCard,
}

/// This widgets models a bottom sheet responsible for creating and editing single cards.
///
/// Notice that it does not touch the database on its own - you have to provide meaningful handlers for the [onSubmit]
/// and [onDelete] events.
class CardForm extends StatefulWidget {
  final CardFormBehavior formBehavior;
  final List<BoxModel> boxes;
  final CardModel card;
  final void Function(CardModel card) onSubmit;
  final void Function(CardModel card) onDelete; // @todo use Optional

  /// Returns a [CardForm] configured to create a new flashcard.
  CardForm.createCard({
    @required this.boxes,
    @required Id deckId,
    @required Id boxId,
    @required this.onSubmit,
  })
      : formBehavior = CardFormBehavior.createCard,
        assert(boxes != null),
        card = CardModel.create(deckId: deckId, boxId: boxId),
        assert(onSubmit != null),
        onDelete = null;

  /// Returns a [CardForm] configured to edit given flashcard.
  CardForm.editCard({
    @required this.boxes,
    @required this.card,
    @required this.onSubmit,
    @required this.onDelete,
  })
      : formBehavior = CardFormBehavior.editCard,
        assert(boxes != null),
        assert(card != null),
        assert(onSubmit != null),
        assert(onDelete != null);

  @override
  _CardFormState createState() {
    return _CardFormState(card);
  }
}

class _CardFormState extends State<CardForm> {
  CardModel card;
  final formKey = GlobalKey<FormState>();

  _CardFormState(this.card);

  @override
  Widget build(BuildContext context) {
    /// Builds bottom sheet's body.
    Widget buildBody() {
      return CardFormBody(
        formKey: formKey,
        boxes: widget.boxes,
        card: card,

        onChanged: (card) {
          setState(() {
            this.card = card;
          });
        },
      );
    }

    /// Builds bottom sheet's actions.
    List<Widget> buildActions() {
      final actions = <Widget>[];

      // "Delete" button, if applicable
      if (widget.formBehavior == CardFormBehavior.editCard) {
        actions.add(
          FlatButton(
            child: const Text('USUŃ'),
            onPressed: maybeDelete,
          ),
        );
      }

      // "Submit" button
      actions.add(
        FlatButton(
          child: const Text('ZAPISZ'),
          onPressed: submit,
        ),
      );

      return actions;
    }

    return WillPopScope(
      onWillPop: confirmDismiss,

      child: frontend.BottomSheet(
        title: Optional.of(
          (widget.formBehavior == CardFormBehavior.createCard)
              ? 'Tworzenie fiszki'
              : 'Edycja fiszki',
        ),

        body: buildBody(),
        actions: buildActions(),
      ),
    );
  }

  /// Returns whether this form is dirty (i.e. whether it contains any unsaved changes).
  bool isDirty() {
    return !card.isEqualTo(widget.card);
  }

  /// Submits this form.
  void submit() {
    widget.onSubmit(card);

    Navigator.pop(context);
  }

  /// Asks user whether they want to delete this flashcard and, if confirmed, deletes it.
  Future<void> maybeDelete() async {
    final confirmed = await confirm(
      context: context,
      title: 'Usunąć fiszkę?',
      message: 'Czy chcesz usunąć tę fiszkę?',
      btnYes: 'USUŃ',
      btnNo: 'NIE USUWAJ',
    );

    if (confirmed) {
      widget.onDelete(widget.card);

      Navigator.pop(context);
    }
  }

  /// Asks user whether they want to abandon the form and, if confirmed, pops back to the previous screen.
  Future<void> maybeDismiss() async {
    if (await confirmDismiss()) {
      Navigator.pop(context);
    }
  }

  /// Asks user whether they want to abandon the form and returns the confirmation's result.
  Future<bool> confirmDismiss() async {
    // If the form's not dirty, don't bother asking user
    if (!isDirty()) {
      return true;
    }

    String message;

    switch (widget.formBehavior) {
      case CardFormBehavior.createCard:
        message = 'Czy chcesz porzucić tworzenie tej fiszki?';
        break;

      case CardFormBehavior.editCard:
        message = 'Czy chcesz porzucić edycję tej fiszki?';
        break;
    }

    return await confirm(
      context: context,
      title: 'Porzucić fiszkę?',
      message: message,
      btnNo: 'WRÓĆ DO FORMULARZA',
      btnYes: 'PORZUĆ',
    );
  }
}
