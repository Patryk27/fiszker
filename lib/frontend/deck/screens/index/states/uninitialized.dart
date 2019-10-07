import 'package:flutter/material.dart';

import '../states.dart';
import '../views.dart';

class UninitializedState extends BlocState {
  @override
  Widget render() {
    return const UninitializedView();
  }
}