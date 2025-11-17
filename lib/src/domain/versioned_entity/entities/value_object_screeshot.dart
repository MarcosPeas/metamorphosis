import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

class ValueObjectScreeshot {
  final String id;
  final String name;
  final String type;
  final bool isNullable;
  final bool isUnique;

  ValueObjectScreeshot({
    required this.id,
    required this.name,
    required this.type,
    required this.isNullable,
    required this.isUnique,
  });

  factory ValueObjectScreeshot.fromValueObject(ValueObject valueObject) {
    return ValueObjectScreeshot(
      id: valueObject.id,
      name: valueObject.name,
      type: valueObject.type,
      isNullable: valueObject.isNullable,
      isUnique: valueObject.isUnique,
    );
  }
}
