import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

@immutable
abstract class Model {
  const Model({
    @required this.id,
  }) : assert(id != null);

  final Id id;
}
