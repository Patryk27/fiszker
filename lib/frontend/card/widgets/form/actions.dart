import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class CardFormActions extends StatelessWidget {
  final CardFormBehavior formBehavior;
  final CardModel card;
  final void Function() onSubmit;
  final void Function() onDelete;
  final void Function() onDismiss;

  CardFormActions({
    @required this.formBehavior,
    @required this.card,
    @required this.onSubmit,
    @required this.onDelete,
    @required this.onDismiss,
  })
      : assert(formBehavior != null),
        assert(card != null),
        assert(onSubmit != null),
        assert(onDelete != null),
        assert(onDismiss != null);

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    // "Cancel" button
    buttons.add(FlatButton(
      child: const Text('ANULUJ'),
      onPressed: onDismiss,
    ));

    // "Delete" button, if applicable
    if (formBehavior == CardFormBehavior.updateCard) {
      buttons.add(FlatButton(
        child: const Text('USUŃ'),
        onPressed: () async {
          final confirmed = await confirm(
            context: context,
            title: 'Usunąć fiszkę?',
            message: 'Czy chcesz usunąć tę fiszkę?',
            btnYes: 'USUŃ',
            btnNo: 'NIE USUWAJ',
          );

          if (confirmed) {
            onDelete();
          }
        },
      ));
    }

    // "Save" button
    buttons.add(FlatButton(
      child: const Text('ZAPISZ'),
      onPressed: onSubmit,
    ));

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: ButtonTheme.bar(
        child: ButtonBar(
          children: buttons,
        ),
      ),
    );
  }
}
