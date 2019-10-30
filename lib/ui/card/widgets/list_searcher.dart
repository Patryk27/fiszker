import 'package:flutter/material.dart';

class CardListSearcher extends StatelessWidget {
  /// Controller for this field's text input.
  final TextEditingController controller;

  CardListSearcher({
    @required this.controller,
  }) : assert(controller != null);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: TextFormField(
        controller: controller,

        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),

          hintText: 'Szukaj wśród fiszek...',
          alignLabelWithHint: true,

          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),

            onPressed: () {
              // https://github.com/flutter/flutter/issues/35848
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                // Clear the input
                controller.clear();

                // Dismiss the keyboard
                FocusScope
                    .of(context)
                    .unfocus();
              });
            },
          ),

          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 14),
        ),
      ),
    );
  }
}
