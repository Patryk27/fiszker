import 'package:optional/optional.dart';

/// Compares two given values and returns:
///   a) `Optional.empty()` - if they are the same,
///   b) `Optional.of(newValue)` - if they are different.
Optional<T> compare<T>(T oldValue, T newValue) {
  return (oldValue == newValue)
      ? Optional.empty()
      : Optional.of(newValue);
}
