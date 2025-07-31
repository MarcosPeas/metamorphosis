import 'dart:convert';

import 'package:metamorphis/src/domain/entity_rule_condition/entity_rule_condition.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/data/reference/models/reference_model.dart';
import 'package:metamorphis/src/infrastructure/data/value_object/models/value_object_model.dart';

class EntityRuleConditionModel extends EntityRuleCondition {
  EntityRuleConditionModel._({
    required super.id,
    required super.logicOperator,
    required super.targetValue,
    required super.comparatorOperator,
    required super.leftValueObject,
    required super.rightValueObject,
    required super.composition,
  });

  factory EntityRuleConditionModel.fromEntity(
    EntityRuleCondition entityRuleCondition,
  ) {
    return EntityRuleConditionModel._(
      id: entityRuleCondition.id,
      logicOperator: entityRuleCondition.logicOperator,
      targetValue: entityRuleCondition.targetValue,
      comparatorOperator: entityRuleCondition.comparatorOperator,
      leftValueObject: entityRuleCondition.leftValueObject,
      rightValueObject: entityRuleCondition.rightValueObject,
      composition: entityRuleCondition.composition,
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
    Reference? composition,
  }) {
    return EntityRuleConditionModel._(
      id: id ?? this.id,
      logicOperator: logicOperator ?? this.logicOperator,
      targetValue: targetValue ?? this.targetValue,
      comparatorOperator: comparatorOperator ?? this.comparatorOperator,
      leftValueObject: leftValueObject ?? this.leftValueObject,
      rightValueObject: rightValueObject ?? this.rightValueObject,
      composition: composition ?? this.composition,
    );
  }

  EntityRuleCondition toEntity() {
    return EntityRuleCondition(
      id: id,
      logicOperator: logicOperator,
      targetValue: targetValue,
      comparatorOperator: comparatorOperator,
      leftValueObject: leftValueObject,
      rightValueObject: rightValueObject,
      composition: composition,
    );
  }

  factory EntityRuleConditionModel.fromMap(Map<String, dynamic> map) {
    ValueObject? leftValueObject;
    ValueObject? rightValueObject;
    Reference? composition;
    if (map['leftValueObject'] != null) {
      leftValueObject = ValueObjectModel.fromMap(map['leftValueObject']);
    }
    if (map['rightValueObject'] != null) {
      rightValueObject = ValueObjectModel.fromMap(map['rightValueObject']);
    }
    if (map['reference'] != null) {
      composition = ReferenceModel.fromMap(map['reference']);
    }
    return EntityRuleConditionModel._(
      id: map['id'],
      logicOperator: map['logicOperator'],
      targetValue: map['targetValue'],
      comparatorOperator: map['comparatorOperator'],
      leftValueObject: leftValueObject,
      rightValueObject: rightValueObject,
      composition: composition,
    );
  }

  factory EntityRuleConditionModel.fromJson(String json) {
    return EntityRuleConditionModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    ValueObjectModel? leftValueObject;
    ValueObjectModel? rightValueObject;
    ReferenceModel? composition;
    if (this.leftValueObject != null) {
      leftValueObject = ValueObjectModel.fromValueObject(this.leftValueObject!);
    }
    if (this.rightValueObject != null) {
      rightValueObject = ValueObjectModel.fromValueObject(
        this.rightValueObject!,
      );
    }
    if (this.composition != null) {
      composition = ReferenceModel.fromEntity(this.composition!);
    }
    return {
      'id': id,
      'logicOperator': logicOperator,
      'targetValue': targetValue,
      'comparatorOperator': comparatorOperator,
      'leftValueObject': leftValueObject?.toMap(),
      'rightValueObject': rightValueObject?.toMap(),
      'reference': composition?.toMap(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
