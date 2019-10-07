import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class UninitializedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const LoadingScreen(
      title: 'Fiszker',
      message: 'Trwa wczytywanie aplikacji - jeszcze sekundka...',
    );
  }
}
