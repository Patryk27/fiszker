import 'package:bloc/bloc.dart';
import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'states.dart';

class ExerciseRevealBloc extends Bloc<BlocEvent, BlocState> {
  final DeckFacade deckFacade;

  ExerciseRevealBloc({
    @required this.deckFacade,
  }) : assert(deckFacade != null);

  /// Returns [ExerciseRevealBloc] related to given [context].
  /// See: [BlocProvider.of].
  static ExerciseRevealBloc of(BuildContext context) {
    return BlocProvider.of<ExerciseRevealBloc>(context);
  }

  @override
  BlocState get initialState {
    return UninitializedState();
  }

  @override
  Stream<BlocState> mapEventToState(BlocEvent event) {
    return event.mapToState(this);
  }
}
