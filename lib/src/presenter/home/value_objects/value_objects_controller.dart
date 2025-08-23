import 'dart:developer';

import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
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

  Future<void> createValueObject(ValueObject valueObject) async {
    final entity = entityStore.entity;
    final hasAnyVOWithName = entity.valueObjects.any(
      (e) => e.name.toLowerCase() == valueObject.name.toLowerCase(),
    );
    if (hasAnyVOWithName) {
      FlashyFlushbar(
        leadingWidget: const Icon(
          Icons.error,
          color: Colors.deepOrange,
          size: 24,
        ),
        message: 'An item with that name already exists',
        duration: const Duration(seconds: 5),
        trailingWidget: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 24),
          onPressed: () {
            FlashyFlushbar.cancel();
          },
        ),
        isDismissible: false,
      ).show();
      return;
    }
    entity.valueObjects.add(valueObject);
    updateEntity();
  }

  Future<void> updateValueObject(ValueObject valueObject) async {
    final entity = entityStore.entity;
    final index = entity.valueObjects.indexWhere(
      (vo) => vo.id == valueObject.id,
    );
    if (index < 0) {
      log('ValueObject with id ${valueObject.id} not found in entity.');
      return;
    }
    entity.valueObjects[index] = valueObject;
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

  Future<void> updateEntity() async {
    final result = await updateEntityUseCase.execute(entityStore.entity);
    result.fold((exception) {
      log(exception.message);
      log(exception.trace);
      entityStore.error = exception;
    }, (_) => entityStore.notifyUpdate());
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
  }) {
    final condition = ValueObjectRuleCondition(
      id: const Uuid().v4(),
      logicOperator: logicOperator,
      targetValue: targetValue,
      comparatorOperator: comparatorOperator,
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

  Future<void> removeValueObjectRule({
    required int viewIndex,
    required ValueObjectRule rule,
  }) async {
    final entity = entityStore.entity;
    final valueObject = entity.valueObjects[viewIndex];
    valueObject.removeRule(rule);
    updateEntity();
  }

  void updateValueObjectRule({
    required String errorMessage,
    required int viewIndex,
    required ValueObjectRule rule,
  }) {
    final entity = entityStore.entity;
    final valueObject = entity.valueObjects[viewIndex];
    rule.errorMessage = errorMessage.trim();
    valueObject.updateRule(rule);
    updateEntity();
  }
}
