import 'package:fiszker/database.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import 'body/name_field.dart';

class BoxFormBody extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final BoxFormBehavior formBehavior;
  final BoxModel box;
  final void Function(BoxModel box) onChanged;

  BoxFormBody({
    @required this.formKey,
    @required this.formBehavior,
    @required this.box,
    @required this.onChanged,
  })
      : assert(formKey != null),
        assert(formBehavior != null),
        assert(box != null),
        assert(onChanged != null);

  @override
  State<BoxFormBody> createState() => _BoxFormBodyState();
}

class _BoxFormBodyState extends State<BoxFormBody> {
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    children.add(
      BoxNameField(
        box: widget.box,
        onChanged: widget.onChanged,
      ),
    );

    if (widget.formBehavior == BoxFormBehavior.editBox) {
      children.addAll([
        const SizedBox(height: 20),

        Details(
          children: [
            // Created at
            Detail.ago(
              title: 'Utworzone:',
              value: Optional.of(widget.box.createdAt),
            ),

            // Exercised at
            Detail.ago(
              title: 'Ostatnio ćwiczone:',
              value: widget.box.exercisedAt,
            ),
          ],
        ),
      ]);
    }

    return Form(
      key: widget.formKey,

      child: Column(
        children: children,
      ),
    );
  }
}
