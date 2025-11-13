import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity/repositories/entity_repository.dart';
import 'package:metamorphis/src/infrastructure/data/entity/models/entity_model.dart';
import 'package:metamorphis/src/infrastructure/data/global_enumerator/model/global_enumerator_model.dart';

class EntityRepositoryImpl implements EntityRepository {
  final _firestore = FirebaseFirestore.instance;
  final _entityCollection = 'entities';
  final _enumeratorCollection = 'global_enumerators';

  @override
  Future<Entity> getById(String id) async {
    try {
      final result = await _firestore
          .collection(_entityCollection)
          .doc(id)
          .get();
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
  Future<List<Entity>> filter(PaginateParams params) async {
    try {
      final result = await _firestore
          .collection(_entityCollection)
          .where(params.filterBy ?? '', isEqualTo: params.filterValue)
          .get();
      final models = result.docs.map((e) {
        return EntityModel.fromMap(e.data());
      }).toList();
      return models;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRepositoryImpl.filter',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar as entidades',
        trace: s.toString(),
        context: 'EntityRepositoryImpl.filter',
      );
    }
  }

  @override
  Future<Entity> save(Entity entity) async {
    try {
      final doc = _firestore.collection(_entityCollection).doc(entity.id);
      final applicationModel = EntityModel.fromEntity(entity);
      await doc.set(applicationModel.toMap());
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
      final batch = _firestore.batch();
      final entityDoc = _firestore.collection(_entityCollection).doc(entity.id);
      for (final enumerator in entity.globalEnumerators) {
        final enumeratorDoc = _firestore
            .collection(_enumeratorCollection)
            .doc(enumerator.enumerator!.id);
        final enumeratorModel = GlobalEnumeratorModel.fromEntity(
          enumerator.enumerator!,
        );
        batch.set(enumeratorDoc, enumeratorModel.toMap());
      }
      final entityModel = EntityModel.fromEntity(entity);
      batch.set(entityDoc, entityModel.toMap());
      await batch.commit();
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
  Future<void> delete(Entity entity) async {
    try {
      _firestore.collection(_entityCollection).doc(entity.id).delete();
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

  @override
  Future<Page<Entity>> paginate(Filter filter) {
    // TODO: implement paginate
    throw UnimplementedError();
  }

  @override
  Future<List<Entity>> updateAll(List<Entity> entities) async {
    try {
      final batch = _firestore.batch();
      for(final entity in entities) {
        final model = EntityModel.fromEntity(entity);
        final ref = _firestore.collection(_entityCollection).doc(entity.id);
        batch.update(ref, model.toMap());
      }
      await batch.commit();
      return entities;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRepositoryImpl.updateAll',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível atualizar as entidades',
        trace: s.toString(),
        context: 'EntityRepositoryImpl.updateAll',
      );
    }
  }
}
