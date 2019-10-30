import 'package:bloc/bloc.dart';
import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class PlayingBloc extends Bloc<PlayingBlocEvent, PlayingBlocState> {
  /// Current exercise.
  final Exercise exercise;

  /// Whether the UI overlay with progress bar and exit button should be visible or not.
  /// When this value gets switched off, the overlay will gradually fade out.
  bool showOverlay = false;

  PlayingBloc({
    @required this.exercise,
  });

  /// Returns [PlayingBloc] related to given [context].
  /// See: [BlocProvider.of].
  static PlayingBloc of(BuildContext context) => BlocProvider.of<PlayingBloc>(context);

  @override
  PlayingBlocState get initialState => AwaitingStart();

  @override
  Stream<PlayingBlocState> mapEventToState(PlayingBlocEvent event) => event.mapToState(this);
}
