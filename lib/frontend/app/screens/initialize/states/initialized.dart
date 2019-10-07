import 'package:flutter/material.dart';

import '../states.dart';
import '../views.dart';

class InitializedState extends BlocState {
  @override
  Widget render() {
    return InitializedView();
  }
}
