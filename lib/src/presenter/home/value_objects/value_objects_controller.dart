import 'dart:developer';

import 'package:flashy_flushbar/flashy_flushbar.dart';
import 'package:flutter/material.dart';
import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';
import 'package:metamorphis/src/presenter/_core/app_store.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';
import 'package:metamorphis/src/presenter/home/_core/entity_store.dart';
import 'package:uuid/uuid.dart';

class ValueObjectsController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;
  final AppStore appStore;

  ValueObjectsController({
    required this.entityStore,
    required this.updateEntityUseCase,
    required this.appStore,
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
      _showDuplicatedErrorMessage();
      return;
    }
    entity.changeValueObject(valueObject, appStore.version + 1);
    updateEntity();
  }

  Future<void> updateValueObject(ValueObject valueObject) async {
    final entity = entityStore.entity;
    final vos = [...entity.valueObjects];
    vos.removeWhere((item) => item.id == valueObject.id);
    final hasAnyVOWithName = vos.any(
      (e) => e.name.toLowerCase() == valueObject.name.toLowerCase(),
    );
    if (hasAnyVOWithName) {
      _showDuplicatedErrorMessage();
      return;
    }
    final index = entity.valueObjects.indexWhere(
      (vo) => vo.id == valueObject.id,
    );
    if (index < 0) {
      log('ValueObject with id ${valueObject.id} not found in entity.');
      return;
    }
    entity.changeValueObject(valueObject, appStore.version + 1);    
    updateEntity();
  }

  Future<void> deleteValueObject({
    required ValueObject valueObject,
    required int viewIndex,
  }) async {
    final entity = entityStore.entity;
    entity.removeValueObject(valueObject, appStore.version + 1);
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
    entity.addRule(rule, valueObject);
    updateEntity();
  }

  Future<void> updateEntity() async {
    final entity = entityStore.entity;
    appStore.updateEntity(entity);
    final result = await updateEntityUseCase.execute(entityStore.entity);
    result.fold((exception) {
      log(exception.message);
      log(exception.trace);
      entityStore.error = exception;
    }, (_) => entityStore.notifyUpdate());
  }

  void createValueObjectGroupCondition({
    required ValueObjectRule rule,
    required ValueObject valueObject,
    required String value,
  }) {
    rule.groupConditions.add(
      ValueObjectGroupCondition(
        logicOperator: value,
        valueObjectRuleId: rule.id,
      ),
    );
    final entity = entityStore.entity;
    entity.updateRule(rule, valueObject);
    updateEntity();
  }

  void createValueObjectRuleCondition({
    required ValueObjectGroupCondition group,
    required String logicOperator,
    required String targetValue,
    required String comparatorOperator,
    required ValueObjectRule rule,
    required ValueObject valueObject,
  }) {
    final condition = ValueObjectRuleCondition(
      id: const Uuid().v4(),
      logicOperator: logicOperator,
      targetValue: targetValue,
      comparatorOperator: comparatorOperator,
      valueObjectGroupConditionId: group.id,
    );
    group.conditions.add(condition);
    rule.updateGroup(group);
    final entity = entityStore.entity;
    entity.updateRule(rule, valueObject);
    updateEntity();
  }

  void removeValueObjectRuleCondition({
    required ValueObjectGroupCondition group,
    required ValueObjectRuleCondition condition,
    required ValueObject valueObject,
    required ValueObjectRule rule,
  }) {
    group.removeCondition(condition);
    rule.updateGroup(group);
    valueObject.updateRule(rule);
    final entity = entityStore.entity;
    entity.updateRule(rule, valueObject);
    updateEntity();
  }

  void removeValueObjectGroupCondition({
    required ValueObjectRule rule,
    required ValueObjectGroupCondition groupCondition,
    required ValueObject valueObject,
  }) {
    rule.groupConditions.remove(groupCondition);
    final entity = entityStore.entity;
    entity.updateRule(rule, valueObject);
    updateEntity();
  }

  Future<void> removeValueObjectRule({
    required int viewIndex,
    required ValueObjectRule rule,
  }) async {
    final entity = entityStore.entity;
    final valueObject = entity.valueObjects[viewIndex];
    entity.removeRule(rule, valueObject);
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
    entity.updateRule(rule, valueObject);
    updateEntity();
  }

  void _showDuplicatedErrorMessage() {
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
  }
}
