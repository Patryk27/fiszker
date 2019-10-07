import 'package:flutter/material.dart';

export 'states/initialized.dart';
export 'states/uninitialized.dart';

abstract class BlocState {
  Widget render();
}
