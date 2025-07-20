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
  single('single'),
  multi('multi');

  final String name;

  const ReferenceType(this.name);

  static ReferenceType fromString(String value) {
    switch (value) {
      case 'multi':
        return multi;
      case 'single':
        return single;
      default:
        return single;
    }
  }
}
