import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import 'bottom_sheet_title.dart';

class BottomSheet extends StatelessWidget {
  final Optional<String> title;
  final Widget body;
  final List<Widget> actions;

  BottomSheet({
    this.title = const Optional.empty(),
    @required this.body,
    this.actions = const [],
  })
      : assert(title != null),
        assert(body != null),
        assert(actions != null);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);

    // Flutter has a non-bug bug that whenever a keyboard appears above a bottom sheet, it appears... above the bottom
    // sheet, covering the actual sheet's contents (https://github.com/flutter/flutter/issues/18564) - this
    // `AnimatedPadding` thingy is here to remedy that.
    return AnimatedPadding(
      duration: const Duration(milliseconds: 350),
      curve: Curves.decelerate,
      padding: mediaQuery.viewInsets,

      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(BOTTOM_SHEET_BORDER_RADIUS),
          topRight: Radius.circular(BOTTOM_SHEET_BORDER_RADIUS),
        ),

        child: Container(
          width: double.maxFinite,
          color: theme.dialogBackgroundColor,
          child: buildChild(),
        ),
      ),
    );
  }

  Widget buildChild() {
    final children = <Widget>[];

    // Add title, if present
    title.ifPresent((title) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(
            top: DIALOG_PADDING,
          ),

          child: BottomSheetTitle(
            title: title,
          ),
        ),
      );
    });

    // Add body
    children.add(
      Padding(
        padding: const EdgeInsets.only(
          left: DIALOG_PADDING,
          top: DIALOG_PADDING,
          right: DIALOG_PADDING,
        ),

        child: body,
      ),
    );

    // Add actions, if present
    if (actions.isNotEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(
            top: DIALOG_PADDING / 2.0,
          ),

          child: ButtonTheme.bar(
            child: ButtonBar(
              children: actions,
            ),
          ),
        ),
      );
    } else {
      children.add(
        SizedBox(
          height: DIALOG_PADDING,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
