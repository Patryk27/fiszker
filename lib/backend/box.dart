import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

export 'box/models.dart';
export 'box/repositories.dart';
export 'box/requests.dart';

/// This class encapsulates all actions that can be performed on [BoxModel]s.
/// It provides a pretty low-level interface meant for [DeckFacade].
class BoxFacade {
  final BoxRepository boxRepository;

  BoxFacade({
    @required this.boxRepository,
  }) : assert(boxRepository != null);

  /// Creates a brand-new box according to given request.
  Future<void> create(CreateBoxRequest request) async {
    // @todo
  }

  /// Creates a list of brand-new boxes according to given requests.
  Future<void> createMany(List<CreateBoxRequest> requests) async {
    for (final request in requests) {
      await create(request);
    }
  }

  /// Updates related box according to given request.
  Future<void> update(UpdateBoxRequest request) async {
    // @todo
  }

  /// Updates related boxes according to given request.
  Future<void> updateMany(List<UpdateBoxRequest> requests) async {
    for (final request in requests) {
      await update(request);
    }
  }

  /// Returns all boxes that belong to given deck.
  Future<List<BoxModel>> findByDeck(DeckModel deck) async {
    return await boxRepository.findByDeckId(deck.id);
  }

  /// Deletes given box.
  Future<void> delete(BoxModel box) async {
    await boxRepository.remove(box.id);
  }

  /// Deletes given boxes.
  Future<void> deleteMany(List<BoxModel> boxes) async {
    for (final box in boxes) {
      await delete(box);
    }
  }
}
