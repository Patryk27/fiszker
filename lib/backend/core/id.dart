import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
class Id extends Equatable implements Comparable {
  final String _id;

  const Id(this._id) : assert(_id != null);

  static Id create() {
    return Id(
      Uuid().v4(),
    );
  }

  /// Serializes this [Id] into a string.
  String serialize() {
    return _id.toString();
  }

  /// Creates a new [Id] from given serialized string.
  static Id deserialize(String value) {
    return Id(value);
  }

  @override
  String toString() {
    return _id.toString();
  }

  @override
  List<Object> get props {
    return [_id];
  }

  @override
  int compareTo(other) {
    if (other is Id) {
      return _id.compareTo(other._id);
    } else {
      return 0;
    }
  }
}
