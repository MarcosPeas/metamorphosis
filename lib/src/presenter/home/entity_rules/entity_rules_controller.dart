import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/composition/entities/composition.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/entity_rule_condition/entity_rule_condition.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/presenter/home/_core/entity_store.dart';

class EntityRulesController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;

  EntityRulesController({
    required this.entityStore,
    required this.updateEntityUseCase,
  });

  void init() {}

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

  void addEntityRule(String errorMessage) {
    final entity = entityStore.entity;
    final entityRule = EntityRule(
      errorMessage: errorMessage,
      entityId: entity.id,
    );
    entity.entityRules.add(entityRule);
    updateEntity();
  }

  void removeEntityRule(EntityRule entityRule) {
    final entity = entityStore.entity;
    entity.entityRules.remove(entityRule);
    updateEntity();
  }

  void createEntityRuleCondition({
    required EntityRuleGroupCondition group,
    required String logicOperator,
    required String targetValue,
    required String comparatorOperator,
    required dynamic leftObject,
    required ValueObject? rightValueObject,
  }) {
    final entityRuleCondition = EntityRuleCondition(
      logicOperator: logicOperator,
      targetValue: targetValue,
      comparatorOperator: comparatorOperator,
      leftValueObject: leftObject is ValueObject ? leftObject : null,
      composition: leftObject is Composition ? leftObject : null,
      rightValueObject: rightValueObject,
    );
    group.conditions.add(entityRuleCondition);
    updateEntity();
  }

  void createEntityRuleGroupCondition({
    required EntityRule rule,
    required String value,
  }) {
    final group = EntityRuleGroupCondition(
      logicOperator: value,
      entityRuleId: rule.id,
    );
    rule.groupConditions.add(group);
    updateEntity();
  }

  void editEntityRule({
    required EntityRule entityRule,
    required String errorMessage,
  }) {
    entityRule.errorMessage = errorMessage;
    updateEntity();
  }

  void deleteEntityRule(EntityRule entityRule) {
    final entity = entityStore.entity;
    entity.entityRules.remove(entityRule);
    updateEntity();
  }

  void removeGroupCondition({
    required List<EntityRuleGroupCondition> groupsConditions,
    required EntityRuleGroupCondition groupCondition,
  }) {
    groupsConditions.remove(groupCondition);
    updateEntity();
  }

  void deleteEntityRuleGroupCondition({
    required EntityRule entityRule,
    required EntityRuleGroupCondition groupCondition,
  }) {
    entityRule.groupConditions.remove(groupCondition);
    updateEntity();
  }

  void removeCondition(
    EntityRuleGroupCondition groupCondition,
    EntityRuleCondition condition,
  ) {
    groupCondition.conditions.remove(condition);
    updateEntity();
  }
}
