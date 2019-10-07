import 'package:flutter/material.dart';

import '../states.dart';
import '../views.dart';

/// This class models a state where the system is during committing data into the database.
/// At this point the form cannot be modified anymore.
class SubmittingState extends BlocState {
  @override
  Widget render() {
    return const SubmittingView();
  }
}