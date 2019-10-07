import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'states.dart';

class DeckIndexBloc extends Bloc<BlocEvent, BlocState> {
  final DeckFacade deckFacade;

  DeckIndexBloc({
    @required this.deckFacade,
  }) : assert(deckFacade != null);

  /// Returns [DeckIndexBloc] related to given [context].
  /// See: [BlocProvider.of].
  static DeckIndexBloc of(BuildContext context) {
    return BlocProvider.of<DeckIndexBloc>(context);
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
