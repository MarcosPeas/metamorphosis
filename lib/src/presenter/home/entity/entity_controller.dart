import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';
import 'package:metamorphis/src/presenter/home/entity/entity_store.dart';

class EntityController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;

  EntityController({
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
    required bool nullable,
  }) async {
    final entity = entityStore.entity;
    final valueObject = ValueObject(
      name: name,
      entityId: entity.id,
      type: type,
      nullable: nullable,
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
    valueObject.nullable = nullable;
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
}
