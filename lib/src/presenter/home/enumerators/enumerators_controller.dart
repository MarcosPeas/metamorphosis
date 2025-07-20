import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/enumerator/entities/enumerator.dart';
import 'package:metamorphis/src/presenter/home/_core/entity_store.dart';

class EnumeratorsController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;

  EnumeratorsController({
    required this.entityStore,
    required this.updateEntityUseCase,
  });

  Future<void> updateEntity() async {
    final result = await updateEntityUseCase.execute(entityStore.entity);
    result.fold((exception) {
      log(exception.message);
      log(exception.trace);
      entityStore.error = exception;
    }, (_) => entityStore.notifyUpdate());
  }

  void createEnumerator({required String name, required String values}) {
    final enumerator = Enumerator(
      name: name,
      values: values,
    );
    entityStore.entity.enumerators.add(enumerator);
    updateEntity();
  }

  void updateEnumerator(Enumerator enumerator) {
    final index = entityStore.entity.enumerators.indexWhere(
      (item) => item.id == enumerator.id,
    );
    if (index >= 0) {
      entityStore.entity.enumerators[index] = enumerator;
      updateEntity();
      return;
    }
    log('Enumerator with id ${enumerator.id} not found');
  }

  void deleteEnumerator(Enumerator enumerator) {
    entityStore.entity.enumerators.removeWhere((item) {
      return item.id == enumerator.id;
    });
    updateEntity();
  }
}
