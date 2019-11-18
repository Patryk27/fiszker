import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';

import '../bloc.dart';

class Start extends RevealExerciseBlocEvent {
  final DeckEntity deck;
  final BoxModel box;
  final ExerciseMode mode;

  Start(this.deck, this.box, this.mode)
      : assert(deck != null),
        assert(box != null),
        assert(mode != null);

  @override
  Stream<RevealExerciseBlocState> mapToState(RevealExerciseBloc bloc) async* {
    yield Playing(
      deck: deck,
      box: box,
      mode: mode,
    );
  }
}
