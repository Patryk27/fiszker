import 'package:fiszker/domain.dart';
import 'package:flutter/material.dart';

class ExerciseModeDropdown extends StatefulWidget {
  final void Function(ExerciseMode value) onChanged;

  ExerciseModeDropdown({
    @required this.onChanged,
  }) : assert(onChanged != null);

  @override
  State<ExerciseModeDropdown> createState() => _ExerciseModeDropdownState();
}

class _ExerciseModeDropdownState extends State<ExerciseModeDropdown> {
  /// Currently selected mode.
  ExerciseMode value = ExerciseMode.oldestTenCards;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,

      decoration: InputDecoration(
        labelText: 'Wybierz tryb',
        alignLabelWithHint: true,
      ),

      items: [
        // Oldest ten cards
        DropdownMenuItem(
          value: ExerciseMode.oldestTenCards,
          child: const Text('Najstarsze 10 fiszek z pudełka'),
        ),

        // Oldest twenty cards
        DropdownMenuItem(
          value: ExerciseMode.oldestTwentyCards,
          child: const Text('Najstarsze 20 fiszek z pudełka'),
        ),

        // Oldest fifty cards
        DropdownMenuItem(
          value: ExerciseMode.oldestFiftyCards,
          child: const Text('Najstarsze 50 fiszek z pudełka'),
        ),

        // All cards
        DropdownMenuItem(
          value: ExerciseMode.allCards,
          child: const Text('Wszystkie fiszki z pudełka'),
        ),
      ],

      onChanged: (value) {
        setState(() {
          this.value = value;
        });

        widget.onChanged(value);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    widget.onChanged(value);
  }
}
