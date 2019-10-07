import 'package:flutter/material.dart';

import '../states.dart';
import '../views.dart';

/// This class models a state where the system is awaiting the [Initialize] event.
/// At this point the form cannot be rendered yet, because we are waiting for database.
class UninitializedState extends BlocState {
  @override
  Widget render() {
    return const UninitializedView();
  }
}