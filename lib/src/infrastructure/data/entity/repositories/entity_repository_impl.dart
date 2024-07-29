import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity/repositories/entity_repository.dart';
import 'package:metamorphis/src/infrastructure/data/entity/models/entity_model.dart';

class EntityRepositoryImpl implements EntityRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'entities';

  @override
  Future<Entity> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return EntityModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar a entidade',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<List<Entity>> getByBoundedContext(String boundedContextId) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where('boundedContextId', isEqualTo: boundedContextId)
          .get();
      return result.docs.map((e) => EntityModel.fromMap(e.data())).toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar as entidades',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<Entity> save(Entity application) async {
    try {
      final doc = _firestore.collection(collection).doc(application.id);
      final applicationModel = EntityModel.fromEntity(application);
      await doc.update(applicationModel.toJson());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar a entidade',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<Entity> update(Entity application) async {
    try {
      final doc = _firestore.collection(collection).doc(application.id);
      final applicationModel = EntityModel.fromEntity(application);
      await doc.update(applicationModel.toJson());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar a entidade',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      _firestore.collection(collection).doc(id).delete();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível remover a entidade',
        trace: s.toString(),
      );
    }
  }
}
