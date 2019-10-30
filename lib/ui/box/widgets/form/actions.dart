import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

class BoxFormActions {
  static List<Widget> build({
    @required BoxForm form,
    @required VoidCallback onSubmit,
    @required Optional<VoidCallback> onDelete,
    @required Optional<VoidCallback> onShowCards,
  }) {
    final actions = <Widget>[];

    if (form.formBehavior == BoxFormBehavior.editBox) {
      // "Show related flashcards" button
      actions.add(
        FlatButton(
          child: const Text('POKAŻ FISZKI'),
          onPressed: onShowCards.orElse(null),
        ),
      );

      // "Delete" button
      actions.add(
        FlatButton(
          child: const Text('USUŃ'),
          onPressed: onDelete.orElse(null),
        ),
      );
    }

    // "Submit" button
    actions.add(
      FlatButton(
        child: const Text('ZAPISZ'),
        onPressed: onSubmit,
      ),
    );

    return actions;
  }
}
