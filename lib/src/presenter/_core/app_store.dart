import 'package:metamorphis/src/domain/user/entities/user.dart';
import 'package:metamorphis/src/presenter/_core/store.dart';

class AppStore extends Store {
  User? _user;

  User? get user => _user;

  set user(User? user) {
    _user = user;
    notifyListeners();
  }
}
