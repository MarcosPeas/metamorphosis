import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class EntityStore extends Store {
  late Entity _entity;

  Entity get entity => _entity;

  set entity(Entity entity) {
    _entity = entity;
    notifyListeners();
  }

  void notifyUpdate() {
    notifyListeners();
  }
}
