import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/presenter/home/_core/entity_store.dart';
import 'package:metamorphis/src/presenter/home/home_store.dart';

class UsedEnumeratorsController {
  final EntityStore entityStore;
  final HomeStore homeStore;
  final UpdateEntityUseCase updateEntityUseCase;

  UsedEnumeratorsController({
    required this.entityStore,
    required this.updateEntityUseCase,
    required this.homeStore,
  });

  bool requirementsAreCompleted(
    EntityGlobalEnumerator enumerator, [
    String? oldName,
  ]) {
    final repeated = entityStore.entity.globalEnumerators.any((item) {
      if (oldName != null && item.name == oldName) {
        return false;
      }
      return item.name == enumerator.name;
    });
    if (repeated) {
      return false;
    }
    return enumerator.requirementsAreCompleted;
  }

  Future<void> updateEntity() async {
    final result = await updateEntityUseCase.execute(entityStore.entity);
    result.fold((exception) {
      log(exception.message);
      log(exception.trace);
      entityStore.error = exception;
    }, (_) => entityStore.notifyUpdate());
  }

  void createEnumerator(EntityGlobalEnumerator enumerator) {
    entityStore.entity.addEnumerator(enumerator);
    updateEntity();
  }

  void deleteEnumerator(EntityGlobalEnumerator enumerator) {
    if (enumerator.enumerator != null) {
      entityStore.entity.removeEnumerator(enumerator.enumerator!);
      updateEntity();
    }
  }

  void updateEnumerator(EntityGlobalEnumerator enumerator, int index) {
    entityStore.entity.globalEnumerators[index] = enumerator;
    updateEntity();
  }
}
