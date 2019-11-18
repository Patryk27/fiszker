import 'package:fiszker/domain.dart';

import '../bloc.dart';

class Submitting extends DeckFormBlocState {
  final DeckEntity deck;

  Submitting(this.deck)
      : assert(deck != null);
}
