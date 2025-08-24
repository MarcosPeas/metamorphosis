import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:uuid/uuid.dart';

class Reference {
  late final String id;
  String name;
  Entity entity;
  bool autoLoad;
  ReferenceType referenceType;

  Reference({
    String? id,
    required this.name,
    required this.entity,
    required this.autoLoad,
    required this.referenceType,
  }) {
    this.id = id ?? const Uuid().v4();
  }

  bool isSimilar(Reference other) {
    if (name != other.name) {
      return false;
    }
    return true;
  }
}

enum ReferenceType {
  oneToOne('oneToOne'),
  manyToOne('manyToOne'),
  manyToMany('manyToMany');

  final String name;

  const ReferenceType(this.name);

  static ReferenceType fromString(String value) {
    switch (value) {
      case 'oneToOne':
        return ReferenceType.oneToOne;
      case 'manyToOne':
        return ReferenceType.manyToOne;
      case 'manyToMany':
        return ReferenceType.manyToMany;
      default:
        return ReferenceType.manyToOne;
    }
  }
}
