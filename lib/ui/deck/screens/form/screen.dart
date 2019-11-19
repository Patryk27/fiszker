import 'package:fiszker/database.dart';
import 'package:fiszker/domain.dart';
import 'package:fiszker/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:optional/optional.dart';

import 'bloc.dart';
import 'screen/boxes.dart';
import 'screen/cards.dart';
import 'screen/deck.dart';

class DeckFormScreen extends StatefulWidget {
  final Id deckId;

  DeckFormScreen({
    @required this.deckId,
  }) : assert(deckId != null);

  @override
  State<DeckFormScreen> createState() => _DeckFormScreenState();
}

enum _Status {
  /// The form has been just initialized; right now we only have access to the [DeckFormScreen.deckId] property, since
  /// the deck itself has not been yet loaded from the database.
  ///
  /// From this status, the control can to [Idle].
  Initializing,

  /// The form is ready and awaiting user input.
  ///
  /// From this status, the control can to [Submitting].
  Idle,

  /// The form is being submitted right now.
  ///
  /// From this status, the control can to [Idle].
  Submitting,
}

class _DeckFormScreenState extends State<DeckFormScreen> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  /// This is a controller for the [CardListSearcher] widget.
  /// It's been extracted as far as here, so that we can modify the query programmatically.
  final cardsQueryController = TextEditingController();

  _Status status = _Status.Initializing;

  Optional<DeckEntity> deck = const Optional.empty();
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeckFormBloc, DeckFormBlocState>(
      listener: (context, state) {
        if (state is Initialized) {
          // No need to `setState()`, since the `BlocBuilder` will be called in a moment anyway
          deck = Optional.of(state.deck);
        }

        if (state is Submitting) {
          // No need to `setState()`, since the `BlocBuilder` will be called in a moment anyway
          deck = Optional.of(state.deck);
        }

        if (scaffoldKey.currentState != null) {
          state.onEntered(scaffoldKey.currentState);
        }
      },

      child: BlocBuilder<DeckFormBloc, DeckFormBlocState>(
        builder: (context, state) {
          if (!deck.isPresent) {
            return const LoadingScreen(
              title: 'Trwa wczytywanie...',
              message: 'Trwa wczytywanie...',
            );
          }

          return Scaffold(
            key: scaffoldKey,

            appBar: AppBar(
              title: Text(deck.value.deck.name),

              bottom: TabBar(
                controller: tabController,
                tabs: [
                  const Tab(text: 'Zestaw'),
                  const Tab(text: 'Fiszki'),
                  const Tab(text: 'Pudełka'),
                ],
              ),
            ),

            body: Form(
              key: formKey,

              child: TabBarView(
                controller: tabController,

                children: [
                  DeckFormSection(
                    deck: deck.value,
                  ),

                  CardsFormSection(
                    deck: deck.value,
                    queryController: cardsQueryController,
                    onCreateCard: createCard,
                    onEditCard: editCard,
                  ),

                  BoxesFormSection(
                    deck: deck.value,
                    onCreateBox: createBox,
                    onEditBox: editBox,
                    onMoveBox: moveBox,
                  ),
                ],
              ),
            ),

            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              curve: Curves.bounceIn,
              overlayColor: Colors.black,

              children: [
                SpeedDialChild(
                  child: Icon(Icons.inbox),
                  backgroundColor: Colors.blue,
                  label: 'Dodaj pudełko',
                  labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                  onTap: createBox,
                ),

                SpeedDialChild(
                  child: Icon(Icons.layers),
                  backgroundColor: Colors.green,
                  label: 'Dodaj fiszkę',
                  labelStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                  onTap: createCard,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    DeckFormBloc
        .of(context)
        .add(Initialize(widget.deckId));

    tabController = TabController(
      initialIndex: 1,
      length: 3,
      vsync: this,
    );

    cardsQueryController.addListener(() {
      setState(() {
        // Required for widget to repaint
      });
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    cardsQueryController.dispose();
    super.dispose();
  }

  /// Opens the [CardForm], allowing user to create a new flashcard.
  void createCard() {
    // Navigate to the "Cards" tab;
    // This serves no purpose besides maybe helping user to locate where the newly-created card ended up
    tabController.animateTo(1);

    // Open the card creator
    showCreateCardForm(
      context: context,
      deck: deck.value,

      onSubmit: (card) {
        DeckFormBloc
            .of(context)
            .add(CreateCard(deck.value, card));
      },
    );
  }

  /// Opens the [CardForm], allowing user to edit or delete given flashcard.
  void editCard(CardModel card) {
    showEditCardForm(
      context: context,
      deck: deck.value,
      card: card,

      onSubmit: (card) {
        DeckFormBloc
            .of(context)
            .add(UpdateCard(deck.value, card));
      },

      onDelete: () {
        DeckFormBloc
            .of(context)
            .add(DeleteCard(deck.value, card));
      },
    );
  }

  /// Opens the [BoxForm], allowing user to create a new box.
  void createBox() {
    // Navigate to the "Boxes" tab;
    // This serves no purpose besides maybe helping user to locate where the newly-created box ended up
    tabController.animateTo(2);

    // Open the box creator
    showCreateBoxForm(
      context: context,
      deck: deck.value,

      onSubmit: (box) {
        DeckFormBloc
            .of(context)
            .add(CreateBox(deck.value, box));
      },
    );
  }

  /// Opens the [BoxForm], allowing user to remove existing box.
  void editBox(BoxModel box) {
    showEditBoxForm(
      context: context,
      deck: deck.value,
      box: box,

      onSubmit: (box) {
        DeckFormBloc
            .of(context)
            .add(UpdateBox(deck.value, box));
      },

      onDelete: () {
        DeckFormBloc
            .of(context)
            .add(DeleteBox(deck.value, box));
      },

      onShowCards: () {
        // Update the query
        setState(() {
          cardsQueryController.text = "pudełko:${box.index}";
        });

        // Navigate to the "Cards" tab
        tabController.animateTo(1);
      },
    );
  }

  /// Moves box to specified index.
  Future<void> moveBox(BoxModel box, int newIndex) async {
    DeckFormBloc
        .of(context)
        .add(MoveBox(deck.value, box, newIndex));
  }
}
