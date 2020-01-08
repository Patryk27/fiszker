import 'package:bloc/bloc.dart';
import 'package:fiszker/database.dart';
import 'package:fiszker/debug.dart';
import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'domain.dart';
import 'i18n.dart' as i18n;
import 'ui.dart';

void main() async {
  BlocSupervisor.delegate = BlocErrorHandlerDelegate();
  i18n.inflector = i18n.PolishInflector();

  // ================== //
  // Initialize vendors //
  timeago.setLocaleMessages('en', timeago.PlMessages());

  // =================== //
  // Initialize database //
  final databaseProvider = DatabaseProvider();

  BoxStorage boxStorage;
  CardStorage cardStorage;
  DeckStorage deckStorage;

  if (DEBUG_ENABLE_IN_MEMORY_REPOSITORIES) {
    boxStorage = InMemoryBoxStorage();
    cardStorage = InMemoryCardsStorage();
    deckStorage = InMemoryDeckStorage();
  } else {
    boxStorage = SqliteBoxStorage(databaseProvider);
    cardStorage = SqliteCardStorage(databaseProvider);
    deckStorage = SqliteDeckStorage(databaseProvider);
  }

  // ================= //
  // Initialize domain //
  final deckFacade = DeckFacade.build(boxStorage, cardStorage, deckStorage);
  final exerciseFacade = ExerciseFacade(boxStorage, cardStorage, deckStorage);

  // ==================== //
  // Start the application //
  runApp(
    Fiszker(
      databaseProvider,
      deckFacade,
      exerciseFacade,
    ),
  );
}

class Fiszker extends StatelessWidget {
  final DatabaseProvider databaseProvider;
  final DeckFacade deckFacade;
  final ExerciseFacade exerciseFacade;

  Fiszker(this.databaseProvider, this.deckFacade, this.exerciseFacade);

  @override
  Widget build(BuildContext context) {
    final cardTheme = CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(CARD_BORDER_RADIUS),
        ),
      ),
    );

    final dialogTheme = DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(DIALOG_BORDER_RADIUS),
        ),
      ),
    );

    return MaterialApp(
      title: 'Fiszker',

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.lightGreen,
        cardTheme: cardTheme,
        dialogTheme: dialogTheme,
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        cardTheme: cardTheme,
        dialogTheme: dialogTheme,
      ),

      navigatorKey: AppNavigator.key,

      initialRoute: 'app--initialize',

      routes: {
        'app--initialize': (context) {
          return BlocProvider<AppInitializeBloc>(
            child: AppInitializeScreen(),

            create: (context) {
              return AppInitializeBloc(
                databaseProvider: databaseProvider,
              );
            },
          );
        },

        'app--crash': (context) {
          return AppCrashScreen(
            dump: ModalRoute
                .of(context)
                .settings
                .arguments,
          );
        },

        'decks': (context) {
          return BlocProvider<DeckIndexBloc>(
            child: DeckIndexScreen(),

            create: (context) {
              return DeckIndexBloc(
                deckFacade: deckFacade,
              );
            },
          );
        },

        'decks--edit': (context) {
          return BlocProvider<DeckFormBloc>(
            child: DeckFormScreen(
              deckId: ModalRoute
                  .of(context)
                  .settings
                  .arguments,
            ),

            create: (context) {
              return DeckFormBloc(
                deckFacade: deckFacade,
              );
            },
          );
        },

        'exercises--reveal': (context) {
          return BlocProvider<RevealExerciseBloc>(
            child: RevealExerciseScreen(
              deckId: ModalRoute
                  .of(context)
                  .settings
                  .arguments,
            ),

            create: (context) {
              return RevealExerciseBloc(
                deckFacade: deckFacade,
                exerciseFacade: exerciseFacade,
              );
            },
          );
        },
      },
    );
  }
}
