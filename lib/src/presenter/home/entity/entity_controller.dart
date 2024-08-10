import 'dart:developer';

import 'package:metamorphis/src/application/value_object/delete_value_object_use_case.dart';
import 'package:metamorphis/src/application/value_object/get_value_objects_by_entity_use_case.dart';
import 'package:metamorphis/src/application/value_object/save_value_object_use_case.dart';
import 'package:metamorphis/src/application/value_object/update_value_object_use_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/presenter/home/entity/entity_store.dart';

class EntityController {
  final EntityStore entityStore;
  final GetValueObjectsByEntityUseCase getValueObjectsByEntityUseCase;
  final SaveValueObjectUseCase saveValueObjectUseCase;
  final UpdateValueObjectUseCase updateValueObjectUseCase;
  final DeleteValueObjectUseCase deleteValueObjectUseCase;

  EntityController({
    required this.entityStore,
    required this.getValueObjectsByEntityUseCase,
    required this.saveValueObjectUseCase,
    required this.updateValueObjectUseCase,
    required this.deleteValueObjectUseCase,
  });

  void init(Entity entity) {
    entityStore.clearValueObjects();
    _loadValueObjects(entity);
  }

  Future<void> createValueObject({
    required Entity entity,
    required String name,
    required String type,
    required bool nullable,
  }) async {
    final valueObject = ValueObject(
      name: name,
      entityId: entity.id,
      type: type,
      nullable: nullable,
    );
    final result = await saveValueObjectUseCase.execute(valueObject);
    result.fold(
      (exception) {
        log(exception.message);
        log(exception.trace);
        entityStore.error = exception;
      },
      (valueObject) => entityStore.addValueObject(valueObject),
    );
  }

  Future<void> updateValueObject({
    required Entity entity,
    required String name,
    required String type,
    required bool nullable,
    required int viewIndex,
  }) async {
    final valueObject = entityStore.valueObjects[viewIndex];
    valueObject.name = name;
    valueObject.type = type;
    valueObject.nullable = nullable;
    final result = await updateValueObjectUseCase.execute(valueObject);
    result.fold(
      (exception) {
        log(exception.message);
        log(exception.trace);
        entityStore.error = exception;
      },
      (valueObject) => entityStore.setValueObject(viewIndex, valueObject),
    );
  }

  Future<void> deleteValueObject({
    required ValueObject valueObject,
    required int viewIndex,
  }) async {
    final result = await deleteValueObjectUseCase.execute(valueObject);
    result.fold(
      (exception) {
        log(exception.message);
        log(exception.trace);
        entityStore.error = exception;
      },
      (_) => entityStore.removeValueObject(viewIndex),
    );
  }

  Future<void> _loadValueObjects(Entity entity) async {
    entityStore.loading = true;
    final result = await getValueObjectsByEntityUseCase.execute(entity);
    result.fold(
      (exception) {
        log(exception.message);
        log(exception.trace);
        entityStore.error = exception;
      },
      (valueObjects) {
        entityStore.valueObjects = valueObjects;
        entityStore.loading = false;
      },
    );
  }
}
