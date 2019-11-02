import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/theme.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

import '../bloc.dart';
import 'setting_up/form.dart';
import 'setting_up/start_button.dart';
import 'setting_up/title.dart';

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
          SettingUpTitle(),

          const SizedBox(height: 25),

          SettingUpForm(
            deck: widget.deck,
            box: selectedBox,
            mode: selectedMode,

            onBoxChanged: (box) {
              setState(() {
                selectedBox = box;
              });
            },

            onModeChanged: (mode) {
              setState(() {
                selectedMode = mode;
              });
            },
          ),

          const SizedBox(height: 45),

          SettingUpStartButton(
            onPressed: () {
              RevealExerciseBloc.of(context).add(
                Start(
                  deck: widget.deck,
                  box: selectedBox,
                  mode: selectedMode,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    selectedBox = widget.deck
        .findOccupiedBoxes()
        .first;

    selectedMode = ExerciseMode.oldestTenCards;
  }
}
