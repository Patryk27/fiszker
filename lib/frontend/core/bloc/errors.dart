import 'package:bloc/bloc.dart';
import 'package:fiszker/backend.dart';
import 'package:fiszker/debug.dart';

class BlocErrorHandlerDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    if (DEBUG_LOG_BLOC_EVENTS) {
      print(event);
    }

    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (DEBUG_LOG_BLOC_TRANSITIONS) {
      print(transition);
    }

    super.onTransition(bloc, transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    if (DEBUG_LOG_BLOC_ERRORS) {
      print('!! BLoC has encountered an error !!');
      print(bloc);
      print(error);
      print(stacktrace);
    }

    // Build error message
    String dump = '';

    dump += 'bloc = ${bloc.runtimeType.toString()}\n';
    dump += 'error = [${error.runtimeType.toString()}] ${error.toString()}\n';

    // Open the "application has crashed" screen.
    // We're doing it after a delay, because it seems that Flutter has some troubles when navigation is changed during
    // e.g. `initState()` (which may have directly or indirectly caused the exception itself).
    Future.delayed(const Duration(milliseconds: 500), () {
      AppNavigator.key.currentState.pushNamed(
        'app--crash',
        arguments: dump,
      );
    });

    super.onError(bloc, error, stacktrace);
  }
}
