import 'package:flutter/material.dart';

import '../bloc.dart';

class Finishing extends FinishingBlocState {
  @override
  Widget buildWidget() => _Widget();
}

class _Widget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }

  @override
  void initState() {
    super.initState();

    // It seems that Flutter forbids modifying the Navigator directly from the initState() method - thus the delay:
    Future.delayed(const Duration(milliseconds: 1), () {
      Navigator.pop(context);
    });
  }
}
