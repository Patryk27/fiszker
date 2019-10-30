import 'package:flutter/material.dart';

export 'animations/fade_in.dart';
export 'animations/fade_out.dart';
export 'animations/scale_out.dart';

abstract class Animator {
  AnimationController controller;

  Future<void> start() async {
    return await controller.forward(from: 0.0);
  }

  void dispose() {
    controller.dispose();
  }

  Widget buildWidget(Widget child);
}
