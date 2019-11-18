import 'package:fiszker/database.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';
import 'states.dart';

class RevealExerciseScreen extends StatefulWidget {
  final Id deckId;

  RevealExerciseScreen({
    @required this.deckId,
  }) : assert(deckId != null);

  @override
  State<StatefulWidget> createState() => _RevealExerciseScreenState();
}

class _RevealExerciseScreenState extends State<RevealExerciseScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RevealExerciseBloc, RevealExerciseBlocState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: confirmClose,

          child: Theme(
            data: ThemeData.dark(),

            child: Scaffold(
              backgroundColor: const Color.fromARGB(255, 40, 40, 40),
              extendBody: true,
              body: state.buildWidget(),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.bottom,
    ]);

    RevealExerciseBloc
        .of(context)
        .add(Initialize(widget.deckId));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);

    super.dispose();
  }

  /// Asks user whether they want to stop the exercise (if that question makes sense).
  Future<bool> confirmClose() async {
    final state = RevealExerciseBloc
        .of(context)
        .state;

    // It only makes sense to as during the actual exercise - not when user is, for instance, setting things up or
    // reading post-mortem summary
    if (state is Playing) {
      return await confirm(
        context: context,
        title: 'Przerwać ćwiczenie?',
        message: 'Czy chcesz przerwać ćwiczenie?',
        yesLabel: 'TAK',
        noLabel: 'NIE',
      );
    } else {
      return true;
    }
  }
}
