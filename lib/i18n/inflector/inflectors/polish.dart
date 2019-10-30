import 'package:fiszker/i18n.dart';

class PolishInflector implements Inflector {
  final _pluralForms = {
    InflectorVerb.flashcard: {
      InflectorCase.accusative: ['fiszkę', 'fiszki', 'fiszek'],
      InflectorCase.nominative: ['fiszka', 'fiszki', 'fiszek'],
    },
  };

  @override
  String pluralize(InflectorVerb iVerb, InflectorCase iCase, int number) {
    final forms = _pluralForms[iVerb][iCase];
    int form = 0;

    // Rules as per https://www.gnu.org/software/gettext/manual/html_node/Plural-forms.html
    if (number == 1) {
      form = 0;
    } else if (number % 10 >= 2 && number % 10 <= 4 && (number % 100 < 10 || number % 100 >= 20)) {
      form = 1;
    } else {
      form = 2;
    }

    return "$number ${forms[form]}";
  }
}
