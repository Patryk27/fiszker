import 'package:flutter/material.dart';

class CardSideField extends StatefulWidget {
  final String title;
  final String hint;
  final String value;
  final bool autofocus;
  final void Function(String value) onChanged;

  CardSideField({
    @required this.title,
    @required this.hint,
    @required this.value,
    @required this.autofocus,
    @required this.onChanged,
  })
      : assert(title != null),
        assert(hint != null),
        assert(value != null),
        assert(autofocus != null),
        assert(onChanged != null);

  @override
  _CardSideFieldState createState() {
    return _CardSideFieldState();
  }
}

class _CardSideFieldState extends State<CardSideField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: widget.autofocus,

      decoration: InputDecoration(
        hintText: widget.hint,
        labelText: widget.title,
        alignLabelWithHint: true,
      ),

      validator: (value) {
        return value.isEmpty ? 'Treść nie może być pusta.' : null;
      },

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

    controller.text = widget.value;

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
