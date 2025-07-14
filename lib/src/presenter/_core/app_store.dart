import 'package:metamorphis/src/domain/user/entities/user.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';
import 'package:metamorphis/src/presenter/_core/view_models/project_view_model.dart';

import 'view_models/application_view_model.dart';
import 'view_models/entity_view_model.dart';

class AppStore extends Store {
  User? _user;

  ProjectViewModel? _project;
  ApplicationViewModel? _application;
  EntityViewModel? _entity;

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

  ApplicationViewModel? get application => _application;

  set application(ApplicationViewModel? application) {
    _application = application;
    notifyListeners();
  }

  EntityViewModel? get entity => _entity;

  set entity(EntityViewModel? entity) {
    _entity = entity;
    notifyListeners();
  }
}
