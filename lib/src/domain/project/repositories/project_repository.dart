import 'package:metamorphis/src/domain/project/entities/project.dart';

abstract class ProjectRepository {
  Future<Project> save(Project project);

  Future<Project> update(Project project);

  Future<Project> getById(String id);

  Future<List<Project>> getByUser(String userId);

  Future<void> delete(String id);
}
