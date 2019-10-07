import 'answer.dart';

class Answers {
  final List<Answer> _answers;
  int _currentAnswerIdx = 0;

  Answers({
    int numberOfCards,
  })
      : assert(numberOfCards > 0),
        _answers = [] {
    for (var i = 0; i < numberOfCards; i += 1) {
      _answers.add(Answer.pending);
    }
  }

  double calcCorrectRatio() {
    return countCorrect() / count();
  }

  int countCorrect() {
    return _countWhere(Answer.correct);
  }

  void addCorrect() {
    _add(Answer.correct);
  }

  double calcInvalidRatio() {
    return countInvalid() / count();
  }

  int countInvalid() {
    return _countWhere(Answer.invalid);
  }

  void addInvalid() {
    _add(Answer.invalid);
  }

  int count() {
    return _answers.length;
  }

  List<Answer> list() {
    return _answers;
  }

  void _add(Answer answer) {
    _answers[_currentAnswerIdx] = answer;
    _currentAnswerIdx += 1;
  }

  int _countWhere(Answer answer) {
    return _answers
        .where((answer2) => answer2 == answer)
        .length;
  }
}
