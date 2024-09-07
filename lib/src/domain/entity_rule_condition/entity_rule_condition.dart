import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:uuid/uuid.dart';

class EntityRuleCondition {
  late final String id;
  String logicOperator;
  String targetValue;
  String comparatorOperator;
  String regex;
  ValueObject? leftValueObject;
  ValueObject? rightValueObject;

  EntityRuleCondition({
    String? id,
    required this.logicOperator,
    required this.targetValue,
    required this.comparatorOperator,
    required this.regex,
    this.leftValueObject,
    this.rightValueObject,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}
