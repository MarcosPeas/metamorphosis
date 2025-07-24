import 'dart:developer';

import 'package:change_case/change_case.dart';
import 'package:metamorphis/src/application/entity/update_entity_use_case.dart';
import 'package:metamorphis/src/domain/data_class/entities/data_class.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/presenter/_core/utils/in_out_generator.dart';
import 'package:metamorphis/src/presenter/home/_core/entity_store.dart';

class UseCasesController {
  final EntityStore entityStore;
  final UpdateEntityUseCase updateEntityUseCase;

  UseCasesController({
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

  void createCreateUseCase() {
    final entity = entityStore.entity;
    final name = 'Create${entityStore.entity.name.toPascalCase()}';
    final useCase = UseCase(
      name: '${name}UseCase',
      useCaseType: UseCaseType.create,
      entityId: entityStore.entity.id,
    );
    final input = InOutGenerator.generate(
      name: '${name}Input',
      vos: entity.valueObjects,
      type: DataClassType.input,
      useCaseId: useCase.id,
      includeId: false,
    );
    final output = InOutGenerator.generate(
      name: '${name}Output',
      vos: entity.valueObjects,
      type: DataClassType.output,
      useCaseId: useCase.id,
    );
    useCase.input = input;
    useCase.output = output;
    entityStore.entity.useCases.add(useCase);
    updateEntity();
  }

  void createFindByIdUseCase() {
    final entity = entityStore.entity;
    final name = 'Find${entityStore.entity.name.toPascalCase()}ById';
    final useCase = UseCase(
      name: '${name}UseCase',
      useCaseType: UseCaseType.findOne,
      entityId: entityStore.entity.id,
    );
    final input = InOutGenerator.generate(
      name: '${name}Input',
      type: DataClassType.input,
      useCaseId: useCase.id,
    );
    final output = InOutGenerator.generate(
      name: '${name}Output',
      vos: entity.valueObjects,
      type: DataClassType.output,
      useCaseId: useCase.id,
    );
    useCase.input = input;
    useCase.output = output;
    entityStore.entity.useCases.add(useCase);
    updateEntity();
  }

  void createUpdateUseCase() {
    final entity = entityStore.entity;
    final name = 'Update${entityStore.entity.name.toPascalCase()}';
    final useCase = UseCase(
      name: '${name}UseCase',
      useCaseType: UseCaseType.update,
      entityId: entityStore.entity.id,
    );
    final input = InOutGenerator.generate(
      name: '${name}Input',
      vos: entity.valueObjects,
      type: DataClassType.input,
      useCaseId: useCase.id,
    );
    final output = InOutGenerator.generate(
      name: '${name}Output',
      vos: entity.valueObjects,
      type: DataClassType.output,
      useCaseId: useCase.id,
    );
    useCase.input = input;
    useCase.output = output;
    entityStore.entity.useCases.add(useCase);
    updateEntity();
  }

  void createDeleteUseCase() {
    final name = 'Delete${entityStore.entity.name.toPascalCase()}';
    final useCase = UseCase(
      name: '${name}UseCase',
      useCaseType: UseCaseType.delete,
      entityId: entityStore.entity.id,
    );
    final input = InOutGenerator.generate(
      name: '${name}Input',
      type: DataClassType.input,
      useCaseId: useCase.id,
    );
    useCase.input = input;
    entityStore.entity.useCases.add(useCase);
    updateEntity();
  }

  void createPaginateUseCase() {
    final entity = entityStore.entity;
    final name = 'Paginate${entityStore.entity.name.toPascalCase()}';
    final useCase = UseCase(
      name: '${name}UseCase',
      useCaseType: UseCaseType.paginate,
      entityId: entityStore.entity.id,
    );
    final input = InOutGenerator.generate(
      name: '${name}Input',
      vos: entity.valueObjects,
      type: DataClassType.input,
      useCaseId: useCase.id,
    );
    final output = InOutGenerator.generate(
      name: '${name}Output',
      vos: entity.valueObjects,
      type: DataClassType.output,
      useCaseId: useCase.id,
      isList: true,
    );
    useCase.input = input;
    useCase.output = output;
    entityStore.entity.useCases.add(useCase);
    updateEntity();
  }

  void deleteUseCase(UseCase useCase) {
    entityStore.entity.useCases.remove(useCase);
    updateEntity();
  }
}
