import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';

class SettingUpForm extends StatefulWidget {
  final DeckEntity deck;

  final BoxModel box;
  final void Function(BoxModel box) onBoxChanged;

  final ExerciseMode mode;
  final void Function(ExerciseMode mode) onModeChanged;

  SettingUpForm({
    @required this.deck,

    @required this.box,
    @required this.onBoxChanged,

    @required this.mode,
    @required this.onModeChanged,
  })
      : assert(deck != null),
        assert(box != null),
        assert(onBoxChanged != null),
        assert(mode != null),
        assert(onModeChanged != null);

  @override
  State<StatefulWidget> createState() => _SettingUpFormState();
}

class _SettingUpFormState extends State<SettingUpForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "Select box" field
        ExerciseBoxDropdown(
          deck: widget.deck,
          value: widget.box,
          onChanged: widget.onBoxChanged,
        ),

        const SizedBox(height: 15),

        // "Select mode" field
        ExerciseModeDropdown(
          value: widget.mode,
          onChanged: widget.onModeChanged,
        ),
      ],
    );
  }
}
