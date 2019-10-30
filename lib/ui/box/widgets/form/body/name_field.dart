import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';

class BoxNameField extends StatefulWidget {
  final BoxModel box;
  final void Function(BoxModel box) onChanged;

  BoxNameField({
    @required this.box,
    @required this.onChanged,
  })
      : assert(box != null),
        assert(onChanged != null);

  @override
  _BoxNameFieldState createState() => _BoxNameFieldState();
}

class _BoxNameFieldState extends State<BoxNameField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: widget.box.name.isEmpty,

      decoration: InputDecoration(
        hintText: 'Np.: Początek tygodnia',
        labelText: 'Nazwa pudełka',
        alignLabelWithHint: true,
      ),

      validator: (value) {
        return value.isEmpty ? 'Nazwa pudełka nie może być pusta.' : null;
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

    controller.text = widget.box.name;

    controller.addListener(() {
      widget.onChanged(
        widget.box.copyWith(
          name: controller.text.trim(),
        ),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
}
