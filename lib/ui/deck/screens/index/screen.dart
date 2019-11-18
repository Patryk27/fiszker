import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional.dart';

import 'bloc.dart';
import 'events/initialize.dart';
import 'states.dart';

class DeckIndexScreen extends StatefulWidget {
  @override
  State<DeckIndexScreen> createState() => _DeckIndexScreenState();
}

class _DeckIndexScreenState extends State<DeckIndexScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Currently visible screen.
  /// See: [DeckIndexBlocState.buildWidget].
  Optional<Widget> currentScreen;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeckIndexBloc, DeckIndexBlocState>(
      listener: (context, state) {
        state.onEntered(scaffoldKey);
      },

      child: BlocBuilder<DeckIndexBloc, DeckIndexBlocState>(
        builder: (context, state) {
          state.buildWidget(scaffoldKey).ifPresent((newScreen) {
            currentScreen = Optional.of(newScreen);
          });

          return currentScreen.value;
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    DeckIndexBloc
        .of(context)
        .add(Initialize());
  }
}
