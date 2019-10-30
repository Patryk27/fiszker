import 'package:flutter/material.dart';

export 'states/awaiting_start.dart';
export 'states/finishing.dart';
export 'states/showing_boxes.dart';
export 'states/showing_chart.dart';

@immutable
abstract class FinishingBlocState {
  Widget buildWidget();
}
