import 'package:flutter/material.dart';

export 'states/active.dart';
export 'states/summary.dart';
export 'states/uninitialized.dart';

@immutable
abstract class BlocState {
  Widget render();
}
