import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

class CardBoxField extends StatefulWidget {
  final List<BoxModel> boxes;
  final Id value;
  final void Function(Id boxId) onChanged;

  CardBoxField({
    @required this.boxes,
    @required this.value,
    @required this.onChanged,
  })
      : assert(boxes != null),
        assert(value != null),
        assert(onChanged != null);

  @override
  _CardBoxFieldState createState() {
    return _CardBoxFieldState();
  }
}

class _CardBoxFieldState extends State<CardBoxField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: widget.value,

      decoration: InputDecoration(
        labelText: 'Pudełko',
        alignLabelWithHint: true,
      ),

      items: widget.boxes.map((box) {
        return DropdownMenuItem(
          value: box.id,
          child: Text(box.getTitle()),
        );
      }).toList(),

      onChanged: (boxId) {
        widget.onChanged(boxId);
      },
    );
  }
}
