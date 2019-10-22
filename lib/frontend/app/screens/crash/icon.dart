import 'package:flutter/material.dart';

class CrashIcon extends StatelessWidget {
  const CrashIcon();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.error_outline,
      size: 60,
      color: Colors.red,
    );
  }
}
