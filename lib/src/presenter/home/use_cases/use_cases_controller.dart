import 'dart:developer';

import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/presenter/home/entity/entity_store.dart';

class UseCasesController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;

  UseCasesController({
    required this.entityStore,
    required this.updateEntityUseCase,
  });

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

  void createSaveUseCase() {
    final saveUseCase = UseCase(
      name: 'Save${entityStore.entity.name}UseCase',
      useCaseType: UseCaseType.create,
      entityId: entityStore.entity.id,
    );
    entityStore.entity.useCases.add(saveUseCase);
    updateEntity();
  }

  void createFindByIdUseCase() {
    final findById = UseCase(
      name: 'Find${entityStore.entity.name}ByIdUseCase',
      useCaseType: UseCaseType.read,
      entityId: entityStore.entity.id,
    );
    entityStore.entity.useCases.add(findById);
    updateEntity();
  }

  void createUpdateUseCase() {
    final updateUseCase = UseCase(
      name: 'Update${entityStore.entity.name}UseCase',
      useCaseType: UseCaseType.update,
      entityId: entityStore.entity.id,
    );
    entityStore.entity.useCases.add(updateUseCase);
    updateEntity();
  }

  void createDeleteUseCase() {
    final deleteUseCase = UseCase(
      name: 'Delete${entityStore.entity.name}UseCase',
      useCaseType: UseCaseType.delete,
      entityId: entityStore.entity.id,
    );
    entityStore.entity.useCases.add(deleteUseCase);
    updateEntity();
  }

  void createPaginateUseCase({
    required String name,
    required bool isAscending,
    required String orderByField,
    required String searchField,
  }) {
    final paginateUseCase = UseCase(
      name: name,
      useCaseType: UseCaseType.paginate,
      entityId: entityStore.entity.id,
      isAscending: isAscending,
      orderByField: orderByField,
      searchField: searchField,
    );
    entityStore.entity.useCases.add(paginateUseCase);
    updateEntity();
  }

  void deleteUseCase(UseCase useCase) {
    entityStore.entity.useCases.remove(useCase);
    updateEntity();
  }
}
