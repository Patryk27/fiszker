import 'package:flutter/material.dart';

class InitializedView extends StatefulWidget {
  @override
  _InitializedViewState createState() {
    return _InitializedViewState();
  }
}

class _InitializedViewState extends State<InitializedView> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  @override
  void initState() {
    super.initState();

    // It seems that Flutter forbids modifying the Navigator directly from the initState() method - thus the delay:
    Future.delayed(const Duration(milliseconds: 1), () {
      Navigator.pushReplacementNamed(context, 'decks');
    });
  }
}
