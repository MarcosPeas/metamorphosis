import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class GlobalEnumeratorsStore extends Store {
  final _enumerators = <GlobalEnumerator>[];

  List<GlobalEnumerator> get enumerators => _enumerators;

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

  set enumerators(List<GlobalEnumerator> enumerators) {
    _enumerators.clear();
    _enumerators.addAll(enumerators);
    notifyListeners();
  }

  void deleteEnumerator(GlobalEnumerator enumerator) {
    final index = _enumerators.indexWhere((e) => e.id == enumerator.id);
    if (index != -1) {
      _enumerators.removeAt(index);
      notifyListeners();
    }
  }

  void clearEnumerators() {
    _enumerators.clear();
    notifyListeners();
  }
}
