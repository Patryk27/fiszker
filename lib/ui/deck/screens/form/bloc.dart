import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class DeckFormBloc extends Bloc<DeckFormBlocEvent, DeckFormBlocState> {
  final DeckFacade deckFacade;

  DeckFormBloc({
    @required this.deckFacade,
  }) : assert(deckFacade != null);

  /// Returns [DeckFormBloc] related to given [context].
  /// See: [BlocProvider.of].
  static DeckFormBloc of(BuildContext context) => BlocProvider.of<DeckFormBloc>(context);

  @override
  DeckFormBlocState get initialState => Uninitialized();

  @override
  Stream<DeckFormBlocState> mapEventToState(DeckFormBlocEvent event) => event.mapToState(this);
}
