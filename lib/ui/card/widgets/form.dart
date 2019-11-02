import 'package:fiszker/database.dart';
import 'package:fiszker/ui.dart' as frontend;
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

import 'form/body.dart';

typedef void CardFormSubmitHandler(CardModel card);
typedef void CardFormDeleteHandler();

/// Defines how the [CardForm] should act as - that is: whether it's supposed to work in the "Create a flashcard" or
/// "Edit a flashcard" mode.
enum CardFormBehavior {
  createCard,
  editCard,
}

/// This widgets models a bottom sheet responsible for creating and editing single cards.
/// It's a part of the [DeckForm], which is generally used to create and edit decks, their boxes and cards.
///
/// # Safety
///
/// This widget makes no changes to the database on its own - you have to provide meaningful handlers for the [onSubmit]
/// and [onDelete] events.
class CardForm extends StatefulWidget {
  final CardFormBehavior formBehavior;

  /// The card we're creating or editing.
  final CardModel card;

  /// List of all the boxes that belong to this card's deck.
  /// Used to display the "Card's deck:" form field.
  final List<BoxModel> boxes;

  /// Handler for the "form submitted" event.
  /// It's responsible for actually committing data to the database.
  final CardFormSubmitHandler onSubmit;

  /// Handler for the "card deleted" event.
  /// It's optional, because it makes sense only combined with [CardFormBehavior.editCard].
  final Optional<CardFormDeleteHandler> onDelete;

  CardForm({
    @required this.formBehavior,
    @required this.card,
    @required this.boxes,
    @required this.onSubmit,
    @required this.onDelete,
  })
      : assert(formBehavior != null),
        assert(card != null),
        assert(boxes != null),
        assert(onSubmit != null),
        assert(onDelete != null);

  @override
  State<CardForm> createState() => _CardFormState(card);
}

class _CardFormState extends State<CardForm> {
  final formKey = GlobalKey<FormState>();
  CardModel card;

  _CardFormState(this.card);

  @override
  Widget build(BuildContext context) {
    /// Builds form's body.
    Widget buildBody() {
      return CardFormBody(
        formKey: formKey,
        card: card,
        boxes: widget.boxes,

        onChanged: (card) {
          setState(() {
            this.card = card;
          });
        },
      );
    }

    /// Builds form's actions.
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
      onWillPop: confirmClose,

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

  /// Submits and closes this form.
  void submit() {
    widget.onSubmit(card);
    close();
  }

  /// Asks user whether they want to delete this flashcard and, if confirmed, deletes it.
  Future<void> maybeDelete() async {
    final confirmed = await confirm(
      context: context,
      title: 'Usunąć fiszkę?',
      message: 'Czy chcesz usunąć tę fiszkę?',
      yesLabel: 'USUŃ',
      noLabel: 'NIE USUWAJ',
    );

    if (confirmed) {
      widget.onDelete.value();
      close();
    }
  }

  /// Returns whether this form is dirty (i.e. whether it contains any unsaved changes).
  bool isDirty() {
    return card != widget.card;
  }

  /// Asks user whether they want to close this form (if it's dirty) and returns the confirmation's result.
  Future<bool> confirmClose() async {
    // If the form's not dirty, let's not even bother asking user
    if (!isDirty()) {
      return true;
    }

    final action = await confirmEx(
      context: context,

      title: 'Zapisać zmiany?',
      message: 'Fiszka zawiera niezapisane zmiany - czy chcesz je zapisać?',

      actions: [
        Tuple2('dismiss', 'WRÓĆ'),
        Tuple2('discard', 'PORZUĆ'),
        Tuple2('save', 'ZAPISZ'),
      ],

      defaultResult: 'dismiss',
    );

    switch (action) {
      case 'dismiss':
        return false;

      case 'discard':
        return true;

      case 'save':
        submit();
        return false;
    }

    throw 'unreachable';
  }

  /// Asks user whether they want to close this form and, if confirmed, actually closes it.
  Future<void> maybeClose() async {
    if (await confirmClose()) {
      close();
    }
  }

  /// Closes this form, returning control to the parent.
  void close() {
    Navigator.pop(context);
  }
}

/// Opens the [CardForm] in the "Create a card" mode.
Future<void> showCreateCardForm({
  @required BuildContext context,
  @required CardModel card,
  @required List<BoxModel> boxes,
  @required CardFormSubmitHandler onSubmit,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    builder: (context) {
      return CardForm(
        formBehavior: CardFormBehavior.createCard,
        card: card,
        boxes: boxes,
        onSubmit: onSubmit,
        onDelete: const Optional.empty(),
      );
    },
  );
}

/// Opens the [CardForm] in the "Edit a card" mode.
Future<void> showEditCardForm({
  @required BuildContext context,
  @required CardModel card,
  @required List<BoxModel> boxes,
  @required CardFormSubmitHandler onSubmit,
  @required CardFormDeleteHandler onDelete,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    builder: (context) {
      return CardForm(
        formBehavior: CardFormBehavior.editCard,
        card: card,
        boxes: boxes,
        onSubmit: onSubmit,
        onDelete: Optional.of(onDelete),
      );
    },
  );
}
