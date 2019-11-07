import 'package:fiszker/domain.dart';

import '../bloc.dart';

class Submitted extends DeckFormBlocState {
  final DeckEntity deck;

  Submitted(this.deck)
      : assert(deck != null);
}
