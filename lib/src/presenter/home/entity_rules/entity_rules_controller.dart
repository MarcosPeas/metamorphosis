import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/presenter/home/entity/entity_store.dart';

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
}
