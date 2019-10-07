import 'package:flutter/material.dart';

class EmptyList extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String callToAction;
  final void Function() onCallToAction;

  const EmptyList({
    @required this.icon,
    @required this.title,
    this.message,
    this.callToAction,
    this.onCallToAction,
  })
      : assert(icon != null),
        assert(title != null);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    // Add icon
    children.add(Icon(
      icon,
      size: 50,
      color: Colors.grey,
    ));

    // Add title
    children.addAll([
      const SizedBox(height: 10),

      Text(
        title,
        textAlign: TextAlign.center,
        textScaleFactor: 1.2,
      ),
    ]);

    // Add message, if present
    if (message != null) {
      final color = Theme
          .of(context)
          .textTheme
          .caption
          .color;

      children.addAll([
        const SizedBox(height: 10),

        Text(
          message,
          textAlign: TextAlign.center,
          textScaleFactor: 0.95,
          style: TextStyle(color: color),
        ),
      ]);
    }

    // Add call to action, if present
    if (callToAction != null) {
      children.addAll([
        const SizedBox(height: 10),

        RaisedButton(
          child: Text(callToAction),
          onPressed: onCallToAction,
          color: Theme
              .of(context)
              .primaryColor,
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
