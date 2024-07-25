import 'package:metamorphis/src/domain/user/entity/user.dart';

abstract class UserRepository {
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User> save(User user);

  Future<User> update(User user);

  Future<User> getUserById(String id);

  Future<User> getCurrentUser();

  Future<void> signOut();
}
