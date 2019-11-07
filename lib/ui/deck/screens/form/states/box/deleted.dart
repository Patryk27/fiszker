import 'package:flutter/material.dart';

import '../../bloc.dart';

class BoxDeleted extends DeckFormBlocState {
  @override
  void showNotification(ScaffoldState scaffold) {
    scaffold.showSnackBar(SnackBar(
      content: const Text('Pudełko zostało usunięte'),
      duration: const Duration(seconds: 2),
    ));
  }
}
