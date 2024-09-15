import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/collections/entities/entity_list.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/presenter/home/entity/entity_store.dart';

class EntityListsController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;

  EntityListsController({
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

  void createList({
    required String name,
    Entity? entity,
  }) {
    if (entity == null) {
      return;
    }
    final entityList = EntityList(name: name, entity: entity);
    entityStore.entity.lists.add(entityList);
    updateEntity();
  }

  void updateEntityList({
    required String name,
    required Entity entity,
    required EntityList list,
  }) {
    list.name = name;
    list.entity = entity;
    updateEntity();
  }

  void removeEntityList(EntityList list) {
    entityStore.entity.lists.remove(list);
    updateEntity();
  }
}
