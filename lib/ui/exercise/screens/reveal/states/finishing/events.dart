import 'package:flutter/material.dart';

import 'bloc.dart';

export 'events/finish.dart';
export 'events/show_boxes.dart';
export 'events/show_chart.dart';
export 'events/start.dart';

@immutable
abstract class FinishingBlocEvent {
  Stream<FinishingBlocState> mapToState(FinishingBloc bloc);
}
