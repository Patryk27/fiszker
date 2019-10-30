import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class DeckIndexBloc extends Bloc<DeckIndexBlocEvent, DeckIndexBlocState> {
  final DeckFacade deckFacade;

  DeckIndexBloc({
    @required this.deckFacade,
  }) : assert(deckFacade != null);

  /// Returns [DeckIndexBloc] related to given [context].
  /// See: [BlocProvider.of].
  static DeckIndexBloc of(BuildContext context) => BlocProvider.of<DeckIndexBloc>(context);

  @override
  DeckIndexBlocState get initialState => Uninitialized();

  @override
  Stream<DeckIndexBlocState> mapEventToState(DeckIndexBlocEvent event) => event.mapToState(this);
}
