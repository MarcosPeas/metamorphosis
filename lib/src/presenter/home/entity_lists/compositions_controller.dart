import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/composition/entities/composition.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/presenter/home/_core/entity_store.dart';

class CompositionsController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;

  CompositionsController({
    required this.entityStore,
    required this.updateEntityUseCase,
  });

  void init() {}

  Future<void> updateEntity() async {
    final result = await updateEntityUseCase.execute(entityStore.entity);
    result.fold(
      (exception) {
        log(exception.toString());
        entityStore.error = exception;
      },
      (_) => entityStore.notifyUpdate(),
    );
  }

  void createComposition({
    required String name,
    Entity? entity,
    required ReferenceType compositionType,
  }) {
    if (entity == null) {
      return;
    }
    final entityList = Reference(
      name: name,
      entity: entity,
      referenceType: compositionType,
    );
    entityStore.entity.compositions.add(entityList);
    updateEntity();
  }

  void updateComposition({
    required String name,
    required Entity entity,
    required Reference list,
    required ReferenceType compositionType,
  }) {
    list.name = name;
    list.referenceType = compositionType;
    list.entity = entity;
    updateEntity();
  }

  void removeComposition(Reference list) {
    entityStore.entity.compositions.remove(list);
    updateEntity();
  }
}
