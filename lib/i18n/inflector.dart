import 'inflector/case.dart';
import 'inflector/verb.dart';

export 'inflector/case.dart';
export 'inflector/inflectors.dart';
export 'inflector/verb.dart';

Inflector inflector;

/// This class is responsible for providing accurate translations regarding the numerals.
/// It allows us to contextually translate verbs
abstract class Inflector {
  /// Returns string containing given number with appropriate numeral.
  ///
  /// ```dart
  /// print(inflector.pluralize(InflectorVerb.flashcard, InflectorCase.nominative, 3)); // '3 fiszki'
  /// ```
  String pluralize(InflectorVerb iVerb, InflectorCase iCase, int number);
}
