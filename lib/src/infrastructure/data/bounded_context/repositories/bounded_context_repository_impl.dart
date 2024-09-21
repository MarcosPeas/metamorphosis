import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';
import 'package:metamorphis/src/domain/bounded_context/repositories/bounded_context_repository.dart';
import 'package:metamorphis/src/infrastructure/data/bounded_context/models/bounded_context_model.dart';

class BoundedContextRepositoryImpl implements BoundedContextRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'boundedContexts';

  @override
  Future<BoundedContext> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return BoundedContextModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.getById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar o contexto delimitado',
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.getById',
      );
    }
  }

  @override
  Future<List<BoundedContext>> getByApplication(String applicationId) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where('applicationId', isEqualTo: applicationId)
          .get();
      return result.docs
          .map((e) => BoundedContextModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.getByApplication',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar os contextos delimitados',
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.getByApplication',
      );
    }
  }

  @override
  Future<BoundedContext> save(BoundedContext application) async {
    try {
      final doc = _firestore.collection(collection).doc(application.id);
      final applicationModel = BoundedContextModel.fromEntity(application);
      await doc.set(applicationModel.toJson());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar o contexto delimitado',
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.save',
      );
    }
  }

  @override
  Future<BoundedContext> update(BoundedContext application) async {
    try {
      final doc = _firestore.collection(collection).doc(application.id);
      final applicationModel = BoundedContextModel.fromEntity(application);
      await doc.update(applicationModel.toJson());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar o contexto delimitado',
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.update',
      );
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      _firestore.collection(collection).doc(id).delete();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.delete',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível remover o contexto delimitado',
        trace: s.toString(),
        context: 'BoundedContextRepositoryImpl.delete',
      );
    }
  }
}
