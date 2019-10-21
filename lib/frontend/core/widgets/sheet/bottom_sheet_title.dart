import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';

class BottomSheetTitle extends StatelessWidget {
  final String title;

  const BottomSheetTitle({
    @required this.title,
  }) : assert(title != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Semantics(
          header: true,

          child: Text(
            title,
            style: theme.textTheme.title,
          ),
        ),

        const SizedBox(height: DIALOG_PADDING),
      ],
    );
  }
}
