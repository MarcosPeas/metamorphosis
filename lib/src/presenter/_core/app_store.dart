import 'package:metamorphis/src/domain/user/entities/user.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';
import 'package:metamorphis/src/presenter/_core/view_models/project_view_model.dart';

class AppStore extends Store {
  User? _user;

  ProjectViewModel? _project;

  User? get user => _user;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }

  ProjectViewModel? get project => _project;

  set project(ProjectViewModel? project) {
    _project = project;
    notifyListeners();
  }
}
