import 'package:metamorphis/src/domain/application/entities/application.dart';

abstract class ApplicationRepository {
  Future<Application> save(Application application);

  Future<Application> update(Application application);

  Future<Application> getById(String id);

  Future<List<Application>> getByProject(String projectId);

  Future<void> delete(String id);
}
