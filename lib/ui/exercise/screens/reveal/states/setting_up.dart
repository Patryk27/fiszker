import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/theme.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';

class SettingUp extends RevealExerciseBlocState {
  final DeckEntity deck;

  SettingUp({
    @required this.deck,
  }) : assert(deck != null);

  @override
  Widget buildWidget() => _Widget(deck);
}

class _Widget extends StatefulWidget {
  final DeckEntity deck;

  _Widget(this.deck);

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  BoxModel selectedBox;
  ExerciseMode selectedMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(BODY_PADDING),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          // "Select box" field
          ExerciseBoxDropdown(
            deck: widget.deck,
            onChanged: handleBoxChanged,
          ),

          const SizedBox(height: 15),

          // "Select mode" field
          ExerciseModeDropdown(
            onChanged: handleModeChanged,
          ),

          const SizedBox(height: 25),

          // "Start" button
          RaisedButton(
            child: const Padding(
              padding: const EdgeInsets.all(20),
              child: const Text('ROZPOCZNIJ'),
            ),

            color: Theme
                .of(context)
                .primaryColor,

            onPressed: handleStartPressed,
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    selectedBox = widget.deck.boxes[0];
  }

  void handleBoxChanged(BoxModel box) {
    // No need to invoke `setState()` here, since the `selectedBox` field is not directly bound to any widget
    selectedBox = box;
  }

  void handleModeChanged(ExerciseMode mode) {
    // No need to invoke `setState()` here, since the `selectedMode` field is not directly bound to any widget
    selectedMode = mode;
  }

  void handleStartPressed() {
    RevealExerciseBloc.of(context).add(
      Start(
        deck: widget.deck,
        box: selectedBox,
        mode: selectedMode,
      ),
    );
  }
}
