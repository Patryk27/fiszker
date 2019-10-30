import 'package:flutter/material.dart';

export 'states/finishing.dart';
export 'states/playing.dart';
export 'states/setting_up.dart';
export 'states/uninitialized.dart';

@immutable
abstract class RevealExerciseBlocState {
  Widget buildWidget();
}
