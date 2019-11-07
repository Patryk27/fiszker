import 'package:flutter/material.dart';

import '../../bloc.dart';

class CardCreated extends DeckFormBlocState {
  @override
  void showNotification(ScaffoldState scaffold) {
    scaffold.showSnackBar(SnackBar(
      content: const Text('Fiszka została utworzona'),
      duration: const Duration(seconds: 2),
    ));
  }
}
