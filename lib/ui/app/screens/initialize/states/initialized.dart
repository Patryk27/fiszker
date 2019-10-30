import 'package:flutter/material.dart';

import '../bloc.dart';

class InitializedState extends AppInitializeBlocState {
  @override
  Widget buildWidget() => const _Widget();
}

class _Widget extends StatefulWidget {
  const _Widget();

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  @override
  Widget build(BuildContext context) => const SizedBox();

  @override
  void initState() {
    super.initState();

    // It seems that Flutter forbids modifying the Navigator directly from the initState() method - thus the delay:
    Future.delayed(const Duration(milliseconds: 1), () {
      Navigator.pushReplacementNamed(context, 'decks');
    });
  }
}
