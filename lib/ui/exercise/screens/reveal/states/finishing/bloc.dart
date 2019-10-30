import 'package:bloc/bloc.dart';
import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class FinishingBloc extends Bloc<FinishingBlocEvent, FinishingBlocState> {
  final Exercise exercise;

  FinishingBloc({
    @required this.exercise,
  }) : assert(exercise != null);

  /// Returns [FinishingBloc] related to given [context].
  /// See: [BlocProvider.of].
  static FinishingBloc of(BuildContext context) => BlocProvider.of<FinishingBloc>(context);

  @override
  FinishingBlocState get initialState => AwaitingStart();

  @override
  Stream<FinishingBlocState> mapEventToState(FinishingBlocEvent event) => event.mapToState(this);
}
