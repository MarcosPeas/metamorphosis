import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class HomeStore extends Store {
  final _entities = <Entity>[];
  int _page = 0;

  bool _generating = false;

  bool get generating => _generating;

  set generating(bool value) {
    _generating = value;
    notifyListeners();
  }

  List<Entity> get entities => List.unmodifiable(_entities);

  void setEntities(List<Entity> entities) {
    _entities.clear();
    _entities.addAll(entities);
    notifyListeners();
  }

  set page(int page) {
    if (page == _page) return;
    _page = page;
    notifyListeners();
  }

  int get page => _page;

  void addEntity(Entity entity) {
    _entities.add(entity);
    notifyListeners();
  }

  void updateEntity(Entity entity) {
    final index = _entities.indexWhere((p) => p.id == entity.id);
    if (index != -1) {
      _entities[index] = entity;
      notifyListeners();
    }
  }

  void deleteEntity(Entity entity) {
    _entities.removeWhere((p) => p.id == entity.id);
    notifyListeners();
  }

  void clear() {
    _entities.clear();
  }
}
