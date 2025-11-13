import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class HomeStore extends Store {
  final _entities = <Entity>[];
  final _enumerators = <GlobalEnumerator>[];
  int _page = 0;

  bool _generating = false;

  bool get generating => _generating;

  set generating(bool value) {
    _generating = value;
    notifyListeners();
  }

  List<Entity> get entities => List.unmodifiable(_entities);

  List<GlobalEnumerator> get enumerators => List.unmodifiable(_enumerators);

  set entities(List<Entity> entities) {
    _entities.clear();
    _entities.addAll(entities);
    notifyListeners();
  }

  set enumerators(List<GlobalEnumerator> enumerators) {
    _enumerators.clear();
    _enumerators.addAll(enumerators);
    notifyListeners();
  }

  void addEnumerator(GlobalEnumerator enumerator) {
    _enumerators.add(enumerator);
    notifyListeners();
  }

  void removeEnumerator(GlobalEnumerator enumerator) {
    _enumerators.remove(enumerator);
    notifyListeners();
  }

  void updateEnumerator(GlobalEnumerator enumerator) {
    final index = _enumerators.indexWhere((e) => e.id == enumerator.id);
    if (index != -1) {
      _enumerators[index] = enumerator;
      notifyListeners();
    }
  }

  void deleteEnumerator(GlobalEnumerator enumerator) {
    final index = _enumerators.indexWhere((e) => e.id == enumerator.id);
    if (index != -1) {
      _enumerators.removeAt(index);
      notifyListeners();
    }
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
