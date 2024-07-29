import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';

abstract class BoundedContextRepository {
  Future<BoundedContext> save(BoundedContext boundedContext);

  Future<BoundedContext> update(BoundedContext boundedContext);

  Future<BoundedContext> getById(String id);

  Future<List<BoundedContext>> getByApplication(String applicationId);

  Future<void> delete(String id);
}
