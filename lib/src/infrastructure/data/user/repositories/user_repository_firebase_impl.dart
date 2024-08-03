import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/user/entities/user.dart';
import 'package:metamorphis/src/domain/user/repositories/user_repository.dart';
import 'package:metamorphis/src/infrastructure/data/user/models/user_model.dart';

class UserRepositoryFirebaseImpl implements UserRepository {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final collection = 'users';

  @override
  Future<User> save(User user) async {
    try {
      final model = UserModel.fromEntity(user);
      final dr = _firestore.collection(collection).doc(user.id);
      await dr.set(model.toMap());
      return model;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível registrar o usuário',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<User> update(User user) async {
    try {
      final model = UserModel.fromEntity(user);
      final dr = _firestore.collection(collection).doc(user.id);
      await dr.update(model.toMap());
      return model;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível registrar o usuário',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return User(
        email: result.user!.email!,
        id: result.user!.uid,
        name: result.user!.displayName ?? '-',
      );
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível fazer login',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível fazer logout',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<User> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw DomainException(
        message: 'Não há usuário logado',
        trace: '',
      );
    }
    return User(
      email: currentUser.email!,
      id: currentUser.uid,
      name: currentUser.displayName ?? '-',
    );
  }

  @override
  Future<User> getUserById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return UserModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível carregar o usuário',
        trace: s.toString(),
      );
    }
  }
}
