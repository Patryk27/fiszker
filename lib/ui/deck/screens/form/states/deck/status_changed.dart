import 'package:flutter/material.dart';

import '../../bloc.dart';

class DeckStatusChanged extends DeckFormBlocState {
  @override
  void onEntered(ScaffoldState scaffold) {
    scaffold.showSnackBar(SnackBar(
      content: const Text('Status został zmieniony'),
      duration: const Duration(seconds: 2),
    ));
  }
}
