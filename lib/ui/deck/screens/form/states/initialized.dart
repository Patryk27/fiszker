import 'package:fiszker/domain.dart';

import '../bloc.dart';

class Initialized extends DeckFormBlocState {
  final DeckEntity deck;

  Initialized(this.deck)
      : assert(deck != null);
}
