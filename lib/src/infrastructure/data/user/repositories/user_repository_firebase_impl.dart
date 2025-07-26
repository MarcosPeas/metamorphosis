import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
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
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'UserRepositoryFirebaseImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível registrar o usuário',
        trace: s.toString(),
        context: 'UserRepositoryFirebaseImpl.save',
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
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'UserRepositoryFirebaseImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível registrar o usuário',
        trace: s.toString(),
        context: 'UserRepositoryFirebaseImpl.update',
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
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'UserRepositoryFirebaseImpl.signInWithEmailAndPassword',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível fazer login',
        trace: s.toString(),
        context: 'UserRepositoryFirebaseImpl.signInWithEmailAndPassword',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível fazer logout',
        trace: s.toString(),
        context: 'UserRepositoryFirebaseImpl.signOut',
      );
    }
  }

  @override
  Future<User> getCurrentUser() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw DomainException.of(
        message: 'Não há usuário logado',
        trace: '',
        context: 'UserRepositoryFirebaseImpl.getCurrentUser',
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
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'UserRepositoryFirebaseImpl.getUserById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível carregar o usuário',
        trace: s.toString(),
        context: 'UserRepositoryFirebaseImpl.getUserById',
      );
    }
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<User> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<List<User>> filter(PaginateParams params) {
    // TODO: implement paginate
    throw UnimplementedError();
  }

  @override
  Future<Page<User>> paginate(Filter filter) {
    // TODO: implement paginate
    throw UnimplementedError();
  }
}
