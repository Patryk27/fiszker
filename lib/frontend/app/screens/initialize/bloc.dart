import 'package:bloc/bloc.dart';
import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'states.dart';

class AppInitializeBloc extends Bloc<BlocEvent, BlocState> {
  final DatabaseProvider databaseProvider;

  AppInitializeBloc({
    @required this.databaseProvider,
  }) : assert(databaseProvider != null);

  /// Returns [AppInitializeBloc] related to given [context].
  /// See: [BlocProvider.of].
  static AppInitializeBloc of(BuildContext context) {
    return BlocProvider.of<AppInitializeBloc>(context);
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
