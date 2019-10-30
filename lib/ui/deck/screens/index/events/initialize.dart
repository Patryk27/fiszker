import '../bloc.dart';

class Initialize extends DeckIndexBlocEvent {
  @override
  Stream<DeckIndexBlocState> mapToState(DeckIndexBloc bloc) async* {
    yield await Initialized.create(bloc);
  }
}
