import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:optional/optional.dart';

import '../bloc.dart';

class Initialized extends DeckIndexBlocState {
  final List<DeckEntity> activeDecks;
  final List<DeckEntity> archivedDecks;
  final List<DeckEntity> completedDecks;

  Initialized(this.activeDecks, this.archivedDecks, this.completedDecks)
      : assert(activeDecks != null),
        assert(archivedDecks != null),
        assert(completedDecks != null);

  static create(DeckIndexBloc bloc) async {
    final deckFacade = bloc.deckFacade;

    return Initialized(
      await deckFacade.findByStatus(DeckStatus.active),
      await deckFacade.findByStatus(DeckStatus.archived),
      await deckFacade.findByStatus(DeckStatus.completed),
    );
  }

  @override
  Optional<Widget> buildWidget(GlobalKey<ScaffoldState> scaffoldKey) => Optional.of(_Widget(this, scaffoldKey));
}

class _Widget extends StatefulWidget {
  final Initialized state;
  final GlobalKey<ScaffoldState> scaffoldKey;

  _Widget(this.state, this.scaffoldKey);

  @override
  State<_Widget> createState() => _WidgetState();
}

class _WidgetState extends State<_Widget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,

      child: Scaffold(
        key: widget.scaffoldKey,

        appBar: AppBar(
          title: const Text('Zestawy fiszek'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              DeckListTab(
                title: 'Aktywne',
                decks: widget.state.activeDecks,
              ),

              DeckListTab(
                title: 'Ukończone',
                decks: widget.state.completedDecks,
              ),

              DeckListTab(
                title: 'Zarchiwizowane',
                decks: widget.state.archivedDecks,
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            // Active decks
            DeckListTabView(
              decks: widget.state.activeDecks,

              listBuilder: (context) {
                return DeckList(
                  decks: widget.state.activeDecks,
                  onDeckTapped: openDeck,
                  onDeckLongPressed: editDeck,
                );
              },

              emptyListBuilder: (context) {
                return EmptyList(
                  icon: Icons.layers,
                  title: 'Nie masz aktywnych zestawów',
                  message: 'Aby stworzyć zestaw, naciśnij plus widoczny u dołu ekranu lub wybierz:',
                  callToAction: 'STWÓRZ ZESTAW',
                  onCallToAction: createDeck,
                );
              },
            ),

            // Completed decks
            DeckListTabView(
              decks: widget.state.completedDecks,

              listBuilder: (context) {
                return DeckList(
                  decks: widget.state.completedDecks,
                  onDeckTapped: openDeck,
                  onDeckLongPressed: editDeck,
                );
              },

              emptyListBuilder: (context) {
                return EmptyList(
                  icon: Icons.check,
                  title: 'Nie masz ukończonych zestawów',
                  message: '... ale nie przejmuj się - na pewno w try miga coś uda Ci się ukończyć!',
                );
              },
            ),

            // Archived deck
            DeckListTabView(
              decks: widget.state.archivedDecks,

              listBuilder: (context) {
                return DeckList(
                  decks: widget.state.archivedDecks,
                  onDeckTapped: openDeck,
                  onDeckLongPressed: editDeck,
                );
              },

              emptyListBuilder: (context) {
                return EmptyList(
                  icon: Icons.archive,
                  title: 'Nie masz zarchiwizowanych zestawów',
                  message: 'Tutaj pojawią się wszystkie zestawy fiszek, które zarchiwizujesz.',
                );
              },
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          tooltip: 'Stwórz zestaw',
          onPressed: createDeck,
        ),
      ),
    );
  }

  /// Opens the [DeckActions] widget.
  Future<void> openDeck(DeckEntity deck) async {
    showDeckActions(
      context: context,
      deck: deck,

      onEdit: () {
        editDeck(deck, replaceCurrentRoute: true);
      },

      onDelete: () async {
        if (await deleteDeck(deck)) {
          Navigator.pop(context);
        }
      },

      onExercise: (exercise) {
        startExercise(deck, exercise);
      },
    );
  }

  /// Opens the deck creator.
  Future<void> createDeck() async {
    showCreateDeckForm(
      context: context,

      onSubmit: (deckName) {
        DeckIndexBloc
            .of(context)
            .add(CreateDeck(deckName));
      },
    );
  }

  /// Opens the deck editor.
  ///
  /// The [replaceCurrentRoute] should be `true` if there's a bottom sheet currently opened - this way the transition
  /// will be smoother.
  Future<void> editDeck(DeckEntity deck, {bool replaceCurrentRoute = false}) async {
    if (replaceCurrentRoute) {
      await Navigator.pushReplacementNamed(context, 'decks--edit', arguments: deck.deck.id);
    } else {
      await Navigator.pushNamed(context, 'decks--edit', arguments: deck.deck.id);
    }

    refresh();
  }

  /// Asks user whether they want to delete given deck and, if confirmed, actually deletes it.
  /// Returns a value indicating whether the deck was deleted or not.
  Future<bool> deleteDeck(DeckEntity deck) async {
    final confirmed = await confirm(
      context: context,
      title: 'Usunąć zestaw?',
      message: 'Czy chcesz usunąć ten zestaw fiszek?',
      yesLabel: 'USUŃ',
      noLabel: 'NIE USUWAJ',
    );

    if (confirmed) {
      DeckIndexBloc
          .of(context)
          .add(DeleteDeck(deck));

      refresh();
    }

    return confirmed;
  }

  /// Starts specified exercise.
  Future<void> startExercise(DeckEntity deck, String exercise) async {
    await Navigator.pushReplacementNamed(context, 'exercises--$exercise', arguments: deck.deck.id);

    refresh();
  }

  /// Refreshes list of our decks.
  /// Should be called each time a deck is created, modified or deleted.
  void refresh() {
    DeckIndexBloc
        .of(context)
        .add(Refresh());
  }
}
