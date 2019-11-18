import 'package:fiszker/ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import 'form_create/name_field.dart';

typedef void CreateDeckFormSubmitHandler(String deckName);

void showCreateDeckForm({
  @required BuildContext context,
  @required CreateDeckFormSubmitHandler onSubmit,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,

    builder: (context) {
      return _CreateDeckForm(
        onSubmit: onSubmit,
      );
    },
  );
}

class _CreateDeckForm extends StatefulWidget {
  final CreateDeckFormSubmitHandler onSubmit;

  _CreateDeckForm({
    @required this.onSubmit,
  }) : assert(onSubmit != null);

  @override
  State<StatefulWidget> createState() => _CreateDeckFormState();
}

class _CreateDeckFormState extends State<_CreateDeckForm> {
  final formKey = GlobalKey<FormState>();

  /// Name of the deck user's creating.
  String deckName = '';

  /// Whether current form is valid.
  /// When it's `false`, the submit button will be grayed out.
  bool isFormValid = false;

  /// Whether current form is enable.
  /// When it's `false`, the entire form (including submit button) will be grayed out.
  bool isFormEnabled = true;

  @override
  Widget build(BuildContext context) {
    Widget buildAction() {
      if (isFormEnabled) {
        return FlatButton(
          child: const Text('STWÓRZ ZESTAW'),
          onPressed: isFormValid ? submitForm : null,
        );
      } else {
        return const FlatButton(
          child: const Text('TWORZENIE ZESTAWU, SEKUNDKA...'),
          onPressed: null,
        );
      }
    }

    return ui.BottomSheet(
      title: Optional.of('Jak chcesz nazwać ten zestaw?'),

      body: Form(
        key: formKey,

        child: DeckNameField(
          enabled: isFormEnabled,
          onChanged: onNameChanged,
        ),
      ),

      actions: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: buildAction(),
        ),
      ],
    );
  }

  void onNameChanged(String newName) {
    setState(() {
      deckName = newName;
      validateForm();
    });
  }

  void validateForm() {
    isFormValid = deckName
        .trim()
        .isNotEmpty;
  }

  void submitForm() {
    widget.onSubmit(deckName);

    setState(() {
      // We're disabling the form to prevent user from submitting it twice
      isFormEnabled = false;
    });
  }
}
