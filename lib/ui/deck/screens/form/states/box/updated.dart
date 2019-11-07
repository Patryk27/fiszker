import 'package:flutter/material.dart';

import '../../bloc.dart';

class BoxUpdated extends DeckFormBlocState {
  @override
  void showNotification(ScaffoldState scaffold) {
    scaffold.showSnackBar(SnackBar(
      content: const Text('Pudełko zostało zaktualizowane'),
      duration: const Duration(seconds: 2),
    ));
  }
}
