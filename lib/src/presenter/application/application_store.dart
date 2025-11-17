import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class ApplicationStore extends Store {
  final _applications = <Application>[];

  List<Application> get applications => _applications;

  void setApplications(List<Application> applications) {
    _applications.clear();
    _applications.addAll(applications);
    notifyListeners();
  }

  void addApplication(Application application) {
    _applications.add(application);
    notifyListeners();
  }

  void updateApplication(Application application) {
    final index = _applications.indexWhere((p) => p.id == application.id);
    if (index != -1) {
      _applications[index] = application;
      notifyListeners();
    }
  }

  void deleteApplication(Application application) {
    _applications.removeWhere((p) => p.id == application.id);
    notifyListeners();
  }

  void clear() {
    _applications.clear();
  }
}
