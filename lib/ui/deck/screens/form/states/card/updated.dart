import 'package:flutter/material.dart';

import '../../bloc.dart';

class CardUpdated extends DeckFormBlocState {
  @override
  void showNotification(ScaffoldState scaffold) {
    scaffold.showSnackBar(SnackBar(
      content: const Text('Fiszka została zaktualizowana'),
      duration: const Duration(seconds: 2),
    ));
  }
}
