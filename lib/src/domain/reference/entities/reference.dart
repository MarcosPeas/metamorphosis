import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:uuid/uuid.dart';

class Reference {
  late final String id;
  String name;
  Entity entity;
  ReferenceType referenceType;

  Reference({
    String? id,
    required this.name,
    required this.entity,
    required this.referenceType,
  }) {
    this.id = id ?? const Uuid().v4();
  }
}

enum ReferenceType {
  oneToOne('oneToOne'),
  oneToMany('oneToMany'),
  manyToMany('manyToMany');

  final String name;

  const ReferenceType(this.name);

  static ReferenceType fromString(String value) {
    switch (value) {
      case 'oneToOne':
        return ReferenceType.oneToOne;
      case 'oneToMany':
        return ReferenceType.oneToMany;
      case 'manyToMany':
        return ReferenceType.manyToMany;
      default:
        return ReferenceType.oneToMany;
    }
  }
}
