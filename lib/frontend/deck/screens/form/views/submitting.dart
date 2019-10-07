import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';

class SubmittingView extends StatelessWidget {
  const SubmittingView();

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      title: 'Tworzenie zestawu fiszek', // @todo or editing (!)
      message: 'Trwa zapisywanie...',
    );
  }
}
