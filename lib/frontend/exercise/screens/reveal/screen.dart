import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'events.dart';
import 'states.dart';

class ExerciseRevealScreen extends StatefulWidget {
  final DeckModel deck;

  ExerciseRevealScreen({
    @required this.deck,
  }) : assert(deck != null);

  @override
  State<StatefulWidget> createState() {
    return _ExerciseRevealScreenState();
  }
}

class _ExerciseRevealScreenState extends State<ExerciseRevealScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExerciseRevealBloc, BlocState>(
      builder: (context, state) {
        return state.render();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    ExerciseRevealBloc.of(context).add(
      Start(
        deck: widget.deck,
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);

    super.dispose();
  }
}
