import 'package:metamorphis/src/domain/_core/domain/id_generator.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

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
    this.id = id ?? IdGenerator.generateId();
  }
}
