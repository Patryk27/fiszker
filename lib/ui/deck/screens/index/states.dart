import 'package:flutter/material.dart';

export 'states/initialized.dart';
export 'states/uninitialized.dart';

@immutable
abstract class DeckIndexBlocState {
  Widget buildWidget();
}
