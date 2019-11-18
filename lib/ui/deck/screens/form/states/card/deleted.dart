import 'package:flutter/material.dart';

import '../../bloc.dart';

class CardDeleted extends DeckFormBlocState {
  @override
  void onEntered(ScaffoldState scaffold) {
    scaffold.showSnackBar(SnackBar(
      content: const Text('Fiszka została usunięta'),
      duration: const Duration(seconds: 2),
    ));
  }
}
