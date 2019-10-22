import 'package:flutter/material.dart';

class CrashSubhead extends StatelessWidget {
  const CrashSubhead();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Spróbuj uruchomić aplikację ponownie - jeśli błąd się powtórzy, śmiało pisz na: wychowaniec.patryk@gmail.com',

      textAlign: TextAlign.center,

      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
    );
  }
}
