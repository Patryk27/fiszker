import 'package:fiszker/backend.dart';

class InMemoryBoxRepository implements BoxRepository {
  final Map<Id, Map<String, dynamic>> _boxes = {};

  @override
  Future<void> add(BoxModel box) async {
    _assertNotExists(box.id);

    _boxes[box.id] = box.serialize();
  }

  @override
  Future<List<BoxModel>> findByDeckId(Id id) async {
    return _boxes.values
        .map(BoxModel.deserialize)
        .where((box) => box.deckId == id)
        .toList();
  }

  @override
  Future<void> remove(Id id) async {
    _assertExists(id);

    _boxes.remove(id);
  }

  /// Throws an exception if there's a box with specified id in the database.
  void _assertNotExists(Id id) {
    if (_boxes.containsKey(id)) {
      throw 'repository already contains box [id=$id]';
    }
  }

  /// Throws an exception if there's no box with specified id in the database.
  void _assertExists(Id id) {
    if (!_boxes.containsKey(id)) {
      throw 'repository does not contain box [id=$id]';
    }
  }
}
