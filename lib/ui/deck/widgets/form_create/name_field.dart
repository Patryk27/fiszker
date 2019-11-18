import 'package:flutter/material.dart';

class DeckNameField extends StatefulWidget {
  final bool enabled;
  final void Function(String value) onChanged;

  DeckNameField({
    @required this.enabled,
    @required this.onChanged,
  })
      : assert(enabled != null),
        assert(onChanged != null);

  @override
  State<StatefulWidget> createState() => _DeckNameFieldState();
}

class _DeckNameFieldState extends State<DeckNameField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      enabled: widget.enabled,

      decoration: const InputDecoration(
        hintText: 'Np.: francuski',
        labelText: 'Nazwa zestawu',
        alignLabelWithHint: true,
      ),

      onEditingComplete: () {
        // When user finishes editing, dismiss the keyboard
        FocusScope
            .of(context)
            .unfocus();
      },
    );
  }

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      widget.onChanged(
        controller.text.trim(),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
