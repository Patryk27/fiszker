import 'package:flutter/material.dart';

class ExerciseCloseButton extends StatefulWidget {
  /// Whether the button should be visible.
  /// This widget supports animations on this property.
  final bool visible;

  ExerciseCloseButton({
    @required this.visible,
  }) : assert(visible != null);

  @override
  State<ExerciseCloseButton> createState() => _ExerciseCloseButtonState();
}

class _ExerciseCloseButtonState extends State<ExerciseCloseButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 1000),

      child: IconButton(
        icon: const Icon(Icons.close),

        onPressed: () {
          Navigator.maybePop(context);
        },
      ),
    );
  }
}
