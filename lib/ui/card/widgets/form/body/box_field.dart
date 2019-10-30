import 'package:fiszker/database.dart';
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
  State<CardBoxField> createState() => _CardBoxFieldState();
}

class _CardBoxFieldState extends State<CardBoxField> {
  @override
  Widget build(BuildContext context) {
    final boxes = List.of(widget.boxes);

    boxes.sort((boxA, boxB) => boxA.index.compareTo(boxB.index));

    return DropdownButtonFormField(
      value: widget.value,

      decoration: InputDecoration(
        labelText: 'Pudełko',
        alignLabelWithHint: true,
      ),

      items: boxes.map((box) {
        return DropdownMenuItem(
          value: box.id,
          child: Text(box.name),
        );
      }).toList(),

      onChanged: (boxId) {
        widget.onChanged(boxId);
      },
    );
  }
}
