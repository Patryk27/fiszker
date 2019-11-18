import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

export 'states/deck_created.dart';
export 'states/initialized.dart';
export 'states/uninitialized.dart';

@immutable
abstract class DeckIndexBlocState {
  /// Fired whenever the BLoC's state changes from something else to this one.
  /// Can be used to e.g. create snackbars.
  void onEntered(GlobalKey<ScaffoldState> scaffoldKey) {
    // Does nothing by the default
  }

  /// Fired whenever the screen's widget needs to be rebuilt.
  /// May return [Optional.empty], in which case the currently rendered widget will remain unchanged.
  Optional<Widget> buildWidget(GlobalKey<ScaffoldState> scaffoldKey) => const Optional.empty();
}
