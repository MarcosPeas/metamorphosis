import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:uuid/uuid.dart';

class EntityRuleCondition {
  late final String id;
  String logicOperator;
  String targetValue;
  String comparatorOperator;
  ValueObject? leftValueObject;
  ValueObject? rightValueObject;
  Reference? composition;

  EntityRuleCondition({
    String? id,
    required this.logicOperator,
    required this.targetValue,
    required this.comparatorOperator,
    this.leftValueObject,
    this.rightValueObject,
    this.composition,
  }) {
    this.id = id ?? const Uuid().v4();
  }
}
