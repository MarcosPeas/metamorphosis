import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';
import 'package:uuid/uuid.dart';

import '../_core/entity_store.dart';

class ValueObjectsController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;

  ValueObjectsController({
    required this.entityStore,
    required this.updateEntityUseCase,
  }) {
    entityStore.loading = true;
  }

  void init(EntityViewModel entity) {
    entityStore.entity = entity;
    entityStore.loading = false;
  }

  Future<void> createValueObject({
    required String name,
    required String type,
    required bool isUnique,
    required bool nullable,
  }) async {
    final entity = entityStore.entity;
    final valueObject = ValueObject(
      name: name,
      entityId: entity.id,
      type: type,
      isUnique: isUnique,
      isNullable: nullable,
    );
    entity.valueObjects.add(valueObject);
    updateEntity();
  }

  Future<void> updateValueObject({
    required String name,
    required String type,
    required bool nullable,
    required int viewIndex,
  }) async {
    final entity = entityStore.entity;
    final valueObject = entity.valueObjects[viewIndex];
    valueObject.name = name;
    valueObject.type = type;
    valueObject.isNullable = nullable;
    updateEntity();
  }

  Future<void> deleteValueObject({
    required ValueObject valueObject,
    required int viewIndex,
  }) async {
    final entity = entityStore.entity;
    entity.valueObjects.removeAt(viewIndex);
    updateEntity();
  }

  Future<void> addValueObjectRule({
    required String errorMessage,
    required int viewIndex,
  }) async {
    final entity = entityStore.entity;
    final valueObject = entity.valueObjects[viewIndex];
    final rule = ValueObjectRule(
      errorMessage: errorMessage,
      valueObjectId: valueObject.id,
    );
    valueObject.addRule(rule);
    updateEntity();
  }

  Future<void> removeValueObjectRule({
    required int viewIndex,
    required ValueObjectRule rule,
  }) async {
    final entity = entityStore.entity;
    final valueObject = entity.valueObjects[viewIndex];
    valueObject.removeRule(rule);
    updateEntity();
  }

  Future<void> updateEntity() async {
    final result = await updateEntityUseCase.execute(entityStore.entity);
    result.fold(
      (exception) {
        log(exception.message);
        log(exception.trace);
        entityStore.error = exception;
      },
      (_) => entityStore.notifyUpdate(),
    );
  }

  void createValueObjectGroupCondition({
    required ValueObjectRule rule,
    required String value,
  }) {
    rule.groupConditions.add(
      ValueObjectGroupCondition(
        logicOperator: value,
        valueObjectRuleId: rule.id,
      ),
    );
    updateEntity();
  }

  void createValueObjectRuleCondition({
    required ValueObjectGroupCondition group,
    required String logicOperator,
    required String targetValue,
    required String comparatorOperator,
    required String regex,
  }) {
    final condition = ValueObjectRuleCondition(
      id: const Uuid().v4(),
      logicOperator: logicOperator,
      targetValue: targetValue,
      comparatorOperator: comparatorOperator,
      regex: regex,
      valueObjectGroupConditionId: group.id,
    );
    group.conditions.add(condition);
    updateEntity();
  }

  void removeValueObjectRuleCondition({
    required ValueObjectGroupCondition group,
    required ValueObjectRuleCondition condition,
  }) {
    group.conditions.remove(condition);
    updateEntity();
  }

  void removeValueObjectGroupCondition({
    required ValueObjectRule rule,
    required ValueObjectGroupCondition groupCondition,
  }) {
    rule.groupConditions.remove(groupCondition);
    updateEntity();
  }
}
