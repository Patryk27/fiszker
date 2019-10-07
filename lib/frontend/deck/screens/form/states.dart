import 'package:flutter/material.dart';

export 'states/initialized.dart';
export 'states/submitted.dart';
export 'states/submitting.dart';
export 'states/uninitialized.dart';

@immutable
abstract class BlocState {
  Widget render();
}