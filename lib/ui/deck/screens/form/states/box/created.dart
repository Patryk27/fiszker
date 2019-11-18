import 'package:flutter/material.dart';

import '../../bloc.dart';

class BoxCreated extends DeckFormBlocState {
  @override
  void onEntered(ScaffoldState scaffold) {
    scaffold.showSnackBar(SnackBar(
      content: const Text('Pudełko zostało utworzone'),
      duration: const Duration(seconds: 2),
    ));
  }
}
