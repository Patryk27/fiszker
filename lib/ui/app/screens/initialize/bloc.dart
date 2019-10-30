import 'package:bloc/bloc.dart';
import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events.dart';
import 'states.dart';

export 'events.dart';
export 'states.dart';

class AppInitializeBloc extends Bloc<AppInitializeBlocEvent, AppInitializeBlocState> {
  final DatabaseProvider databaseProvider;

  AppInitializeBloc({
    @required this.databaseProvider,
  }) : assert(databaseProvider != null);

  /// Returns [AppInitializeBloc] related to given [context].
  /// See: [BlocProvider.of].
  static AppInitializeBloc of(BuildContext context) => BlocProvider.of<AppInitializeBloc>(context);

  @override
  AppInitializeBlocState get initialState => UninitializedState();

  @override
  Stream<AppInitializeBlocState> mapEventToState(AppInitializeBlocEvent event) => event.mapToState(this);
}
