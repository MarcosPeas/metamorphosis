import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/user/entities/user.dart';

abstract class UserRepository extends Repository<User> {
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User> getUserById(String id);

  Future<User> getCurrentUser();

  Future<void> signOut();
}
