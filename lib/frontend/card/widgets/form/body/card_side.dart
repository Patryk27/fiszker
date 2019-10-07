import 'package:flutter/material.dart';

class CardSide extends StatefulWidget {
  final String title;
  final String hint;
  final String value;
  final bool autofocus;
  final void Function(String) onChanged;

  CardSide({
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
  _CardSideState createState() {
    return _CardSideState();
  }
}

class _CardSideState extends State<CardSide> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        TextFormField(
          autofocus: widget.autofocus,
          controller: textController,

          decoration: InputDecoration(
            hintText: widget.hint,
            labelText: widget.title,
            alignLabelWithHint: true,
          ),

          validator: (value) {
            return value.isEmpty ? 'Treść nie może być pusta.' : null;
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    textController.text = widget.value;

    textController.addListener(() {
      widget.onChanged(
        textController.text.trim(),
      );
    });
  }

  @override
  void dispose() {
    textController.dispose();

    super.dispose();
  }
}
