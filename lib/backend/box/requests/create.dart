import 'package:fiszker/backend.dart';
import 'package:flutter/material.dart';

@immutable
class CreateBoxRequest {
  final Id id;
  final Id deckId;
  final int index;

  CreateBoxRequest({
    @required this.id,
    @required this.deckId,
    @required this.index,
  })
      : assert(id != null),
        assert(deckId != null),
        assert(index != null);

  /// Transforms given [BoxModel] into a [CreateBoxRequest].
  static CreateBoxRequest fromModel({
    @required BoxModel box,
  }) {
    return CreateBoxRequest(
      id: box.id,
      deckId: box.deckId,
      index: box.index,
    );
  }
}
