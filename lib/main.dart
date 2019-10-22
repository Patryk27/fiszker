import 'package:bloc/bloc.dart';
import 'package:fiszker/debug.dart';
import 'package:fiszker/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'backend.dart';
import 'frontend.dart';

void main() async {
  BlocSupervisor.delegate = BlocErrorHandlerDelegate();

  // Initialize timeago
  timeago.setLocaleMessages('en', timeago.PlMessages());

  // Initialize database provider
  final databaseProvider = DatabaseProvider();

  // Initialize repositories
  BoxRepository boxRepository;
  CardRepository cardRepository;
  DeckRepository deckRepository;

  if (DEBUG_ENABLE_IN_MEMORY_REPOSITORIES) {
    boxRepository = InMemoryBoxRepository();
    cardRepository = InMemoryCardRepository();
    deckRepository = InMemoryDeckRepository();
  } else {
    // @todo boxRepository

    cardRepository = SqliteCardRepository(
      databaseProvider: databaseProvider,
    );

    deckRepository = SqliteDeckRepository(
      databaseProvider: databaseProvider,
    );
  }

  // Initialize facades
  final boxFacade = BoxFacade(
    boxRepository: boxRepository,
  );

  final cardFacade = CardFacade(
    cardRepository: cardRepository,
  );

  final deckFacade = DeckFacade(
    deckRepository: deckRepository,
    boxFacade: boxFacade,
    cardFacade: cardFacade,
  );

  // Start the application
  runApp(Fiszker(
    databaseProvider: databaseProvider,
    deckFacade: deckFacade,
  ));
}

class Fiszker extends StatelessWidget {
  final DatabaseProvider databaseProvider;
  final DeckFacade deckFacade;

  Fiszker({
    @required this.databaseProvider,
    @required this.deckFacade,
  })
      : assert(databaseProvider != null),
        assert(deckFacade != null);

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

            builder: (context) {
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

            builder: (context) {
              return DeckIndexBloc(
                deckFacade: deckFacade,
              );
            },
          );
        },

        'decks--create': (context) {
          return BlocProvider<DeckFormBloc>(
            child: DeckFormScreen.createDeck(),

            builder: (context) {
              return DeckFormBloc(
                deckFacade: deckFacade,
              );
            },
          );
        },

        'decks--edit': (context) {
          return BlocProvider<DeckFormBloc>(
            child: DeckFormScreen.editDeck(
              deck: ModalRoute
                  .of(context)
                  .settings
                  .arguments,
            ),

            builder: (context) {
              return DeckFormBloc(
                deckFacade: deckFacade,
              );
            },
          );
        },

        'exercises--reveal': (context) {
          return BlocProvider<ExerciseRevealBloc>(
            child: ExerciseRevealScreen(
              deck: ModalRoute
                  .of(context)
                  .settings
                  .arguments,
            ),

            builder: (context) {
              return ExerciseRevealBloc(
                deckFacade: deckFacade,
              );
            },
          );
        },
      },
    );
  }
}
