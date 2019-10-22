import 'package:flutter/material.dart';

class CrashHeader extends StatelessWidget {
  const CrashHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'W Fiszkerze wystąpił błąd, przez co nie może on kontynuować działania.',

      textAlign: TextAlign.center,

      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
