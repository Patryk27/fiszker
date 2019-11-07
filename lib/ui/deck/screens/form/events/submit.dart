import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:optional/optional.dart';

import '../bloc.dart';

class Submit extends DeckFormBlocEvent {
  final DeckEntity deck;
  final Optional<DeckFormBlocState> successNotification;

  Submit(this.deck, { DeckFormBlocState successNotification })
      : assert(deck != null),
        successNotification = Optional.ofNullable(successNotification);

  @override
  Stream<DeckFormBlocState> mapToState(DeckFormBloc bloc) async* {
    yield Submitting();
    await bloc.deckFacade.update(deck);
    yield Submitted(deck);

    if (successNotification.isPresent) {
      yield successNotification.value;
    }
  }
}
