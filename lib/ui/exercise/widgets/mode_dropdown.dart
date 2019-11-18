import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';

class ExerciseModeDropdown extends StatefulWidget {
  final ExerciseMode value;
  final void Function(ExerciseMode value) onChanged;

  ExerciseModeDropdown({
    @required this.value,
    @required this.onChanged,
  })
      : assert(value != null),
        assert(onChanged != null);

  @override
  State<ExerciseModeDropdown> createState() => _ExerciseModeDropdownState();
}

class _ExerciseModeDropdownState extends State<ExerciseModeDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: widget.value,

      decoration: const InputDecoration(
        labelText: 'Wybierz tryb',
        alignLabelWithHint: true,
      ),

      items: [
        // Oldest ten cards
        DropdownMenuItem(
          value: ExerciseMode.oldestTenCards,
          child: const Text('Powtórz 10 fiszek'),
        ),

        // Oldest twenty cards
        DropdownMenuItem(
          value: ExerciseMode.oldestTwentyCards,
          child: const Text('Powtórz 20 fiszek'),
        ),

        // Oldest fifty cards
        DropdownMenuItem(
          value: ExerciseMode.oldestFiftyCards,
          child: const Text('Powtórz 50 fiszek'),
        ),

        // All cards
        DropdownMenuItem(
          value: ExerciseMode.allCards,
          child: const Text('Powtórz wszystkie fiszki'),
        ),
      ],

      onChanged: widget.onChanged,
    );
  }
}
