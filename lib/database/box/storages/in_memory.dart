import 'package:fiszker/database.dart';
import 'package:optional/optional.dart';

class InMemoryBoxStorage implements BoxStorage {
  final Map<Id, Map<String, dynamic>> _boxes = {};

  @override
  Future<void> add(BoxModel box) async {
    _assertNotExists(box.id);
    _boxes[box.id] = box.serialize();

    print('(db) Box added: $box');
  }

  @override
  Future<void> update(Id id, {
    Optional<int> index = const Optional.empty(),
    Optional<String> name = const Optional.empty(),
    Optional<Optional<DateTime>> exercisedAt = const Optional.empty(),
  }) async {
    _assertExists(id);

    _boxes.update(id, (box) {
      return BoxModel.deserialize(box).copyWith(
        index: index.orElse(null),
        name: name.orElse(null),
        exercisedAt: exercisedAt.orElse(null),
      ).serialize();
    });

    print('(db) Box updated: id=$id, index=$index, name=$name, exercisedAt=$exercisedAt');
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

    print('(db) Box removed: id=$id');
  }

  void _assertNotExists(Id id) {
    if (_boxes.containsKey(id)) {
      throw 'storage already contains box with id `$id`';
    }
  }

  void _assertExists(Id id) {
    if (!_boxes.containsKey(id)) {
      throw 'storage does not contain box with id `$id`';
    }
  }
}
