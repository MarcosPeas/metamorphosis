import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class EntityStore extends Store {
  final List<ValueObject> _valueObjects = [];

  List<ValueObject> get valueObjects => _valueObjects;

  set valueObjects(List<ValueObject> valueObjects) {
    _valueObjects.clear();
    _valueObjects.addAll(valueObjects);
    notifyListeners();
  }

  void addValueObject(ValueObject valueObject) {
    _valueObjects.add(valueObject);
    notifyListeners();
  }

  void clearValueObjects() {
    _valueObjects.clear();
    notifyListeners();
  }

  void setValueObject(int viewIndex, ValueObject valueObject) {
    _valueObjects[viewIndex] = valueObject;
    notifyListeners();
  }

  void removeValueObject(int viewIndex) {
    _valueObjects.removeAt(viewIndex);
    notifyListeners();
  }
}
