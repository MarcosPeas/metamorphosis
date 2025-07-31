import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/presenter/home/_core/entity_store.dart';

class ReferencesController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;

  ReferencesController({
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

  void createReference({
    required String name,
    Entity? entity,
    required bool autoLoad,
    required ReferenceType compositionType,
  }) {
    if (entity == null) {
      return;
    }
    final entityList = Reference(
      name: name,
      entity: entity,
      autoLoad: autoLoad,
      referenceType: compositionType,
    );
    entityStore.entity.references.add(entityList);
    updateEntity();
  }

  void updateComposition({
    required String name,
    required Entity entity,
    required Reference reference,
    required ReferenceType compositionType,
    required bool autoLoad,
  }) {
    reference.name = name;
    reference.referenceType = compositionType;
    reference.entity = entity;
    reference.autoLoad = autoLoad;
    updateEntity();
  }

  void removeComposition(Reference list) {
    entityStore.entity.references.remove(list);
    updateEntity();
  }
}
