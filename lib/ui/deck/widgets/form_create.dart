import 'package:fiszker/ui.dart' as ui;
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

typedef void CreateDeckFormSubmitHandler(String deckName);

void showCreateDeckForm({
  @required BuildContext context,
  @required CreateDeckFormSubmitHandler onSubmit,
}) {
  showModalBottomSheet(
    context: context,

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
  @override
  Widget build(BuildContext context) {
    return ui.BottomSheet(
      title: Optional.of('Jak chcesz nazwać ten zestaw?'),

      body: const Text('@todo'),
    );
  }
}
