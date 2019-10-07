import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'events.dart';
import 'states.dart';

class DeckFormBloc extends Bloc<BlocEvent, BlocState> {
  final DeckFacade deckFacade;

  DeckFormBloc({
    @required this.deckFacade,
  }) : assert(deckFacade != null);

  /// Returns [DeckFormBloc] related to given [context].
  /// See: [BlocProvider.of].
  static DeckFormBloc of(BuildContext context) {
    return BlocProvider.of<DeckFormBloc>(context);
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
