import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';

abstract class UseCaseRepository {
  Future<UseCase> save(UseCase useCase);

  Future<UseCase> update(UseCase useCase);

  Future<UseCase> getById(String id);

  Future<List<UseCase>> getByEntity(String entityId);

  Future<void> delete(String id);
}
