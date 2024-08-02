import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class ProjectStore extends Store {
  final _projects = <Project>[];

  List<Project> get projects => List.unmodifiable(_projects);

  void setProjects(List<Project> projects) {
    _projects.addAll(projects);
    notifyListeners();
  }

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  void updateProject(Project project) {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      notifyListeners();
    }
  }

  void deleteProject(Project project) {
    _projects.removeWhere((p) => p.id == project.id);
    notifyListeners();
  }
}
