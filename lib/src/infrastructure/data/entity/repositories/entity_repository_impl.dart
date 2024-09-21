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
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRepositoryImpl.getById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar a entidade',
        trace: s.toString(),
        context: 'EntityRepositoryImpl.getById',
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
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRepositoryImpl.getByBoundedContext',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar as entidades',
        trace: s.toString(),
        context: 'EntityRepositoryImpl.getByBoundedContext',
      );
    }
  }

  @override
  Future<Entity> save(Entity entity) async {
    try {
      final doc = _firestore.collection(collection).doc(entity.id);
      final applicationModel = EntityModel.fromEntity(entity);
      await doc.set(applicationModel.toJson());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRepositoryImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a entidade',
        trace: s.toString(),
        context: 'EntityRepositoryImpl.save',
      );
    }
  }

  @override
  Future<Entity> update(Entity entity) async {
    try {
      final doc = _firestore.collection(collection).doc(entity.id);
      final entityModel = EntityModel.fromEntity(entity);
      await doc.set(entityModel.toJson());
      return entityModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRepositoryImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a entidade',
        trace: s.toString(),
        context: 'EntityRepositoryImpl.update',
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
        context: 'EntityRepositoryImpl.delete',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível remover a entidade',
        trace: s.toString(),
        context: 'EntityRepositoryImpl.delete',
      );
    }
  }
}
