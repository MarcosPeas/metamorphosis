import 'package:metamorphis/src/domain/entity_rule_condition/entity_rule_condition.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/data/value_object/models/value_object_model.dart';

class EntityRuleConditionModel extends EntityRuleCondition {
  EntityRuleConditionModel._({
    required super.id,
    required super.logicOperator,
    required super.targetValue,
    required super.comparatorOperator,
    required super.regex,
    required super.leftValueObject,
    required super.rightValueObject,
  });

  factory EntityRuleConditionModel.fromEntity(EntityRuleCondition entityRuleCondition) {
    return EntityRuleConditionModel._(
      id: entityRuleCondition.id,
      logicOperator: entityRuleCondition.logicOperator,
      targetValue: entityRuleCondition.targetValue,
      comparatorOperator: entityRuleCondition.comparatorOperator,
      regex: entityRuleCondition.regex,
      leftValueObject: entityRuleCondition.leftValueObject,
      rightValueObject: entityRuleCondition.rightValueObject,
    );
  }

  EntityRuleConditionModel copyWith({
    String? id,
    String? logicOperator,
    String? targetValue,
    String? comparatorOperator,
    String? regex,
    ValueObject? leftValueObject,
    ValueObject? rightValueObject,
  }) {
    return EntityRuleConditionModel._(
      id: id ?? this.id,
      logicOperator: logicOperator ?? this.logicOperator,
      targetValue: targetValue ?? this.targetValue,
      comparatorOperator: comparatorOperator ?? this.comparatorOperator,
      regex: regex ?? this.regex,
      leftValueObject: leftValueObject ?? this.leftValueObject,
      rightValueObject: rightValueObject ?? this.rightValueObject,
    );
  }

  EntityRuleCondition toEntityRuleCondition() {
    return EntityRuleCondition(
      id: id,
      logicOperator: logicOperator,
      targetValue: targetValue,
      comparatorOperator: comparatorOperator,
      regex: regex,
      leftValueObject: leftValueObject,
      rightValueObject: rightValueObject,
    );
  }

  Map<String, dynamic> toJson() {
    ValueObjectModel? leftValueObject;
    ValueObjectModel? rightValueObject;
    if (this.leftValueObject != null) {
      leftValueObject = ValueObjectModel.fromValueObject(this.leftValueObject!);
    }
    if (this.rightValueObject != null) {
      rightValueObject = ValueObjectModel.fromValueObject(this.rightValueObject!);
    }
    return {
      'id': id,
      'logicOperator': logicOperator,
      'targetValue': targetValue,
      'comparatorOperator': comparatorOperator,
      'regex': regex,
      'leftValueObject': leftValueObject?.toMap(),
      'rightValueObject': rightValueObject?.toMap(),
    };
  }

  factory EntityRuleConditionModel.fromMap(Map<String, dynamic> json) {
    ValueObject? leftValueObject;
    ValueObject? rightValueObject;
    if (json['leftValueObject'] != null) {
      leftValueObject = ValueObjectModel.fromMap(json['leftValueObject']);
    }
    if (json['rightValueObject'] != null) {
      rightValueObject = ValueObjectModel.fromMap(json['rightValueObject']);
    }
    return EntityRuleConditionModel._(
      id: json['id'],
      logicOperator: json['logicOperator'],
      targetValue: json['targetValue'],
      comparatorOperator: json['comparatorOperator'],
      regex: json['regex'],
      leftValueObject: leftValueObject,
      rightValueObject: rightValueObject,
    );
  }
}
