import 'package:flutter/material.dart';

export 'states/box/created.dart';
export 'states/box/deleted.dart';
export 'states/box/updated.dart';
export 'states/card/created.dart';
export 'states/card/deleted.dart';
export 'states/card/updated.dart';
export 'states/deck/status_changed.dart';
export 'states/initialized.dart';
export 'states/submitted.dart';
export 'states/submitting.dart';
export 'states/uninitialized.dart';

@immutable
abstract class DeckFormBlocState {
  void onEntered(ScaffoldState scaffold) {
    // Does nothing by the default
  }
}
