import 'package:flutter/material.dart';

class CrashDump extends StatelessWidget {
  final String dump;

  CrashDump({
    @required this.dump,
  }) : assert(dump != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Błąd:',

          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),

        const SizedBox(height: 12),

        Text(
          dump,

          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
