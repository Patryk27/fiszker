import 'package:fiszker/database.dart';
import 'package:flutter/material.dart';

@immutable
abstract class Model {
  const Model({
    @required this.id,
  }) : assert(id != null);

  final Id id;

  /// Serializes this model into a list of its properties.
  Map<String, dynamic> serialize();

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(other) {
    if (other is Model) {
      // It may not the fastest possible implementation, but it's good enough - it's not like we're comparing hundredths
      // models each frame
      return toString() == other.toString();
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return this.runtimeType.toString() + serialize().toString();
  }
}

/// Transforms `List<Model>` into `Map<Id, Model>`.
Map<Id, T> indexModels<T extends Model>(List<T> models) {
  return Map.fromIterable(
    models,
    key: (model) => model.id,
  );
}
