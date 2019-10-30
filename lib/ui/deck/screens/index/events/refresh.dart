import '../bloc.dart';

class Refresh extends DeckIndexBlocEvent {
  @override
  Stream<DeckIndexBlocState> mapToState(DeckIndexBloc bloc) async* {
    yield Uninitialized();
    yield await Initialized.create(bloc);
  }
}
