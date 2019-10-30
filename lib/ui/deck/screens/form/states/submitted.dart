import 'package:flutter/material.dart';

import '../bloc.dart';

/// This class models a state when the system has just committed data into the database.
/// At this point the form cannot be modified anymore and the navigator should just return to the previous screen.
class Submitted extends DeckFormBlocState {
  @override
  Widget buildWidget() => const SizedBox();
}
