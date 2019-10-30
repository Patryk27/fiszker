import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
class Id implements Comparable {
  final String _id;

  const Id(this._id) : assert(_id != null);

  /// Creates a new, unique identifier.
  static Id create() => Id(Uuid().v4());

  /// Serializes this identifier into a string.
  String serialize() => _id.toString();

  /// Creates an identifier from given serialized string.
  static Id deserialize(String value) => Id(value);

  @override
  String toString() => _id.toString();

  @override
  int get hashCode => _id.hashCode;

  @override
  bool operator ==(other) {
    if (other is Id) {
      return _id == other._id;
    } else {
      return false;
    }
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
