import 'package:fiszker/backend.dart';
import 'package:fiszker/frontend.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:optional/optional.dart';

import 'form/boxes.dart';
import 'form/cards.dart';
import 'form/deck.dart';

/// Defines how the [DeckForm] should act as - that is: whether it's supposed to be "Create a deck" or "Edit a deck"
/// variant.
enum DeckFormBehavior {
  createDeck,
  editDeck,
}

/// This widget models a scaffold responsible for creating and editing single decks.
///
/// Notice that it does not touch the database on its own - you have to provide meaningful handler for the [onSubmit]
/// event.
class DeckForm extends StatefulWidget {
  final DeckFormBehavior formBehavior;

  final DeckModel deck;
  final List<BoxModel> boxes;
  final List<CardModel> cards;

  final void Function(DeckModel deck, List<BoxModel> boxes, List<CardModel> cards) onSubmit;

  /// Returns a [DeckForm] configured to create a new deck.
  DeckForm.createDeck({
    @required this.onSubmit,
  })
      : formBehavior = DeckFormBehavior.createDeck,
        deck = DeckModel.create(),
        boxes = [],
        cards = [],
        assert(onSubmit != null);

  /// Returns a [DeckForm] configured to edit given deck.
  DeckForm.editDeck({
    @required DeckViewModel deck,
    @required this.onSubmit,
  })
      : formBehavior = DeckFormBehavior.editDeck,
        deck = deck.deck,
        boxes = deck.boxes,
        cards = deck.cards,
        assert(onSubmit != null);

  @override
  _DeckFormState createState() {
    return _DeckFormState(
      deck,
      List.of(boxes),
      List.of(cards),
    );
  }
}

class _DeckFormState extends State<DeckForm> with SingleTickerProviderStateMixin {
  _DeckFormState(this.deck, this.boxes, this.cards);

  final formKey = GlobalKey<FormState>();

  /// This is a controller for the [CardListSearcher] widget.
  /// It's been extracted as far as here, so that we can modify the query programmatically.
  final cardsQueryController = TextEditingController();

  TabController tabController;

  DeckModel deck;
  List<BoxModel> boxes;
  List<CardModel> cards;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: confirmDismiss,

      child: Scaffold(
        // Screens's top-bar
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: maybeDismiss,
          ),

          title: (widget.formBehavior == DeckFormBehavior.createDeck)
              ? const Text('Tworzenie zestawu fiszek')
              : const Text('Edycja zestawu fiszek'),

          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: submit,
            ),
          ],

          bottom: TabBar(
            controller: tabController,
            tabs: [
              const Tab(text: 'Zestaw'),
              const Tab(text: 'Fiszki'),
              const Tab(text: 'Pudełka'),
            ],
          ),
        ),

        // Screens's body
        body: Form(
          key: formKey,

          child: TabBarView(
            controller: tabController,

            children: [
              DeckFormDeckSection(
                deck: deck,
                onDeckEdited: handleDeckEdited,
              ),

              DeckFormCardsSection(
                cards: cards,
                boxes: boxes,
                queryController: cardsQueryController,
                onCreateCard: createCard,
                onEditCard: editCard,
              ),

              DeckFormBoxesSection(
                boxes: boxes,
                cards: cards,
                onCreateBox: createBox,
                onShowBox: showBox,
              ),
            ],
          ),
        ),

        // Screens's bottom-bar
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
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(vsync: this, length: 3);

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

  /// Validates the form and, if everything is correct, submits it.
  void submit() {
    // Validate the form; if it's invalid, don't bother submitting
    if (!formKey.currentState.validate()) {
      // Currently only the deck's name can be entered incorrectly here - thanks to this we can safely force-jump to the
      // first tab
      tabController.animateTo(0);

      return;
    }

    widget.onSubmit(deck, boxes, cards);
  }

  /// Opens the [CardForm], allowing user to create a new flashcard.
  Future<void> createCard() async {
    // Navigate to the "Cards" tab
    tabController.animateTo(1);

    // Determine which box is the first one
    final firstBox = boxes.firstWhere((box) => box.index == 1, orElse: () => null);

    if (firstBox == null) {
      // @todo show alert
    } else {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,

        builder: (context) {
          return CardForm.createCard(
            boxes: boxes,
            deckId: deck.id,
            boxId: firstBox.id,
            onSubmit: handleCardCreated,
          );
        },
      );
    }
  }

  /// Opens the [CardForm], allowing user to edit given flashcard.
  Future<void> editCard(CardModel card) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      builder: (context) {
        return CardForm.editCard(
          boxes: boxes,
          card: card,
          onSubmit: handleCardEdited,
          onDelete: handleCardDeleted,
        );
      },
    );
  }

  /// Creates a new box.
  Future<void> createBox() async {
    // Navigate to the "Boxes" tab
    tabController.animateTo(2);

    // Create a box
    final box = BoxModel.create(
      deckId: deck.id,
      index: boxes.length + 1,
    );

    handleBoxCreated(box);
  }

  /// Opens the box's bottom sheet.
  Future<void> showBox(BoxModel box) async {
    final boxCards = cards
        .where((card) => card.boxId == box.id)
        .toList();

    final onShowCardsPressed = boxCards.isEmpty ? null : () {
      setState(() {
        cardsQueryController.text = "pudełko:${box.index}";
      });

      // Navigate to the "Cards" tab
      tabController.animateTo(1);

      // Close the bottom sheet
      Navigator.pop(context);
    };

    final onDeletePressed = (boxes.length == 1) ? null : () {
      // Delete the box
      handleBoxDeleted(box);

      // Close the bottom sheet
      Navigator.pop(context);
    };

    await showModalBottomSheet(
      context: context,

      builder: (context) {
        return BoxBottomSheet(
          box: box,
          boxCards: boxCards,
          onShowCardsPressed: Optional.ofNullable(onShowCardsPressed),
          onDeletePressed: Optional.ofNullable(onDeletePressed),
        );
      },
    );
  }

  /// Handles the "deck edited" event, updating widget's state.
  /// Event originator: [DeckFormDeckSection]
  void handleDeckEdited(DeckModel deck) {
    setState(() {
      this.deck = deck;
    });
  }

  /// Handles the "card created" event, updating widget's state.
  /// Event originator: [DeckFormCardsSection]
  void handleCardCreated(CardModel card) {
    setState(() {
      cards.add(card);
    });
  }

  /// Handles the "card edited" event, updating widget's state.
  /// Event originator: [DeckFormCardsSection]
  void handleCardEdited(CardModel card) {
    setState(() {
      cards
        ..removeWhere((card2) => card2.id == card.id)
        ..add(card);
    });
  }

  /// Handles the "card deleted" event, updating widget's state.
  /// Event originator: [DeckFormCardsSection]
  void handleCardDeleted(CardModel card) {
    setState(() {
      cards.removeWhere((card2) => card2.id == card.id);
    });
  }

  /// Handles the "box created" event, updating widget's state.
  /// Event originator: [DeckFormBoxesSection]
  void handleBoxCreated(BoxModel box) {
    setState(() {
      boxes.add(box);
    });
  }

  /// Handles the "box edited" event, updating widget's state.
  ///
  /// Event originator: [DeckFormBoxesSection]
  ///
  /// Event restrictions: the [BoxModel.index] property must not be changed - if you want to move a box, use the
  /// [handleBoxMoved] method.
  void handleBoxEdited(BoxModel box) {
    setState(() {
      boxes
        ..removeWhere((box2) => box2.id == box.id)
        ..add(box);
    });
  }

  /// Handles the "box moved" event, updating widget's state.
  /// Event originator: [DeckFormBoxesSection]
  void handleBoxMoved(BoxModel box) {
    // @todo
  }

  /// Handles the "box deleted" event, updating widget's state.
  /// Event originator: [DeckFormBoxesSection]
  void handleBoxDeleted(BoxModel box) {
    setState(() {
      // Since we're removing a box, we have to move all the cards that are located inside it to the first box; unless
      // we're removing the first box, in which case we have to move them into the second one
      BoxModel firstBox;

      if (box.index == 1) {
        firstBox = boxes.firstWhere((box) => box.index == 2);
      } else {
        firstBox = boxes.firstWhere((box) => box.index == 1);
      }

      cards = cards.map((card) {
        if (card.belongsToBox(box)) {
          return card.copyWith(
            boxId: firstBox.id,
          );
        } else {
          return card;
        }
      }).toList();

      // Now we have to re-index all the boxes that come after this one, so that we don't end up with a hole in our
      // numeration
      boxes = boxes.map((box2) {
        if (box2.index > box.index) {
          return box2.copyWith(
            index: box2.index - 1,
          );
        } else {
          return box2;
        }
      }).toList();

      // And now, eventually, we can safely delete the box
      boxes..removeWhere((box2) => box2.id == box.id);
    });
  }

  /// Returns whether this form is dirty (i.e. whether it contains any unsaved changes).
  bool isDirty() {
    // Compare deck
    if (!deck.isEqualTo(widget.deck)) {
      return true;
    }

    // Compare boxes
    if (boxes.length != widget.boxes.length) {
      return true;
    }

    for (var i = 0; i < boxes.length; i += 1) {
      if (!boxes[i].isEqualTo(widget.boxes[i])) {
        return true;
      }
    }

    // Compare cards
    if (cards.length != widget.cards.length) {
      return true;
    }

    for (var i = 0; i < cards.length; i += 1) {
      if (!cards[i].isEqualTo(widget.cards[i])) {
        return true;
      }
    }

    return false;
  }

  /// Asks user whether they want to abandon the form and, if confirmed, pops back to the previous screen.
  Future<void> maybeDismiss() async {
    if (await confirmDismiss()) {
      Navigator.pop(context);
    }
  }

  /// Asks user whether they want to abandon the form and returns the confirmation's result.
  Future<bool> confirmDismiss() async {
    // If the form's not dirty, don't bother asking user
    if (!isDirty()) {
      return true;
    }

    String message;

    switch (widget.formBehavior) {
      case DeckFormBehavior.createDeck:
        message = 'Czy chcesz porzucić tworzenie tego zestawu?\nStracisz niezapisane zmiany.';
        break;

      case DeckFormBehavior.editDeck:
        message = 'Czy chcesz porzucić edycję tego zestawu?\nStracisz niezapisane zmiany.';
        break;
    }

    return await confirm(
      context: context,
      title: 'Porzucić zestaw?',
      message: message,
      btnNo: 'WRÓĆ DO FORMULARZA',
      btnYes: 'PORZUĆ',
    );
  }
}
