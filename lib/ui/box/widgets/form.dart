import 'package:fiszker/database.dart';
import 'package:fiszker/ui.dart' as frontend;
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';
import 'package:tuple/tuple.dart';

import 'form/actions.dart';
import 'form/body.dart';

typedef void BoxFormSubmitHandler(BoxModel box);
typedef void BoxFormDeleteHandler();
typedef void BoxFormShowCardsHandler();

/// Defines how the [BoxForm] should act as - that is: whether it's supposed to work in the "Create a box" or "Edit a
/// box" mode.
enum BoxFormBehavior {
  createBox,
  editBox,
}

/// This widget models a bottom sheet responsible for creating and editing single boxes.
/// It's part of the [DeckForm], which is generally used to create and edit decks, their boxes and cards.
///
/// # Safety
///
/// This widget makes no changes to the database on its own - you have to provide meaningful handlers for the [onSubmit]
/// and [onDelete] events.
class BoxForm extends StatefulWidget {
  final BoxFormBehavior formBehavior;

  /// The box we're creating or editing.
  final BoxModel box;

  /// Handler for the "form submitted" event.
  /// It's responsible for actually committing data to the database.
  final BoxFormSubmitHandler onSubmit;

  /// Handler for the "box deleted" event.
  ///
  /// It's optional, because it makes sense only when combined with [BoxFormBehavior.editBox] and when there are at
  /// least three boxes in the entire deck.
  final Optional<BoxFormDeleteHandler> onDelete;

  /// Handler for the "show box cards" event.
  ///
  /// It's optional, because it makes sense only when combined with [BoxFormBehavior.editBox] and when this box contains
  /// any cards in the first place.
  final Optional<BoxFormShowCardsHandler> onShowCards;

  BoxForm({
    @required this.formBehavior,
    @required this.box,
    @required this.onSubmit,
    @required this.onDelete,
    @required this.onShowCards,
  })
      : assert(formBehavior != null),
        assert(box != null),
        assert(onSubmit != null),
        assert(onDelete != null),
        assert(onShowCards != null);

  @override
  State<BoxForm> createState() => _BoxFormState(box);
}

class _BoxFormState extends State<BoxForm> {
  final formKey = GlobalKey<FormState>();
  BoxModel box;

  _BoxFormState(this.box);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmClose,

      child: frontend.BottomSheet(
        // Form's title
        title: Optional.of(
          (widget.formBehavior == BoxFormBehavior.createBox)
              ? 'Tworzenie pudełka'
              : 'Edycja pudełka',
        ),

        // Form's body
        body: BoxFormBody(
          formKey: formKey,
          formBehavior: widget.formBehavior,
          box: box,

          onChanged: (box) {
            setState(() {
              this.box = box;
            });
          },
        ),

        // Form's actions
        actions: BoxFormActions.build(
          form: this.widget,
          onSubmit: submit,
          onDelete: widget.onDelete.map((fn) => () => maybeDelete(fn)),
          onShowCards: widget.onShowCards.map((fn) => () => showCards(fn)),
        ),
      ),
    );
  }

  /// Submits and closes this form.
  void submit() {
    widget.onSubmit(box);
    close();
  }

  /// Goes back to the previous view and shows all the cards related to this box.
  Future<void> showCards(BoxFormShowCardsHandler fn) async {
    // Since this action dismisses the form, it's nice to ask user whether they actually want to leave it
    if (isDirty() && !await confirmClose()) {
      return;
    }

    fn();
    close();
  }

  /// Asks user whether they want to delete this box and, if confirmed, deletes it.
  Future<void> maybeDelete(BoxFormDeleteHandler fn) async {
    final confirmed = await confirm(
      context: context,
      title: 'Usunąć pudełko?',
      message: 'Czy chcesz usunąć to pudełko?\n\nZnajdujące się w nim fiszki zostaną przeniesione do następnego pudełka.',
      yesLabel: 'USUŃ',
      noLabel: 'NIE USUWAJ',
    );

    if (confirmed) {
      fn();
      close();
    }
  }

  /// Returns whether this form is dirty (i.e. whether it contains any unsaved changes).
  bool isDirty() {
    return box != widget.box;
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
      message: 'Pudełko zawiera niezapisane zmiany - czy chcesz je zapisać?',

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

/// Opens the [BoxForm] in the "Create a box" mode.
Future<void> showCreateBoxForm({
  @required BuildContext context,
  @required BoxModel box,
  @required BoxFormSubmitHandler onSubmit,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    builder: (context) {
      return BoxForm(
        formBehavior: BoxFormBehavior.createBox,
        box: box,
        onSubmit: onSubmit,
        onDelete: const Optional.empty(),
        onShowCards: const Optional.empty(),
      );
    },
  );
}

/// Opens the [BoxForm] in the "Edit a box" mode.
Future<void> showEditBoxForm({
  @required BuildContext context,
  @required BoxModel box,
  @required BoxFormSubmitHandler onSubmit,
  @required Optional<BoxFormDeleteHandler> onDelete,
  @required Optional<BoxFormShowCardsHandler> onShowCards,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    builder: (context) {
      return BoxForm(
        formBehavior: BoxFormBehavior.editBox,
        box: box,
        onSubmit: onSubmit,
        onDelete: onDelete,
        onShowCards: onShowCards,
      );
    },
  );
}
