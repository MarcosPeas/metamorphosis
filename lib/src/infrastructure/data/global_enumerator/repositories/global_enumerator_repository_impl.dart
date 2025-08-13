import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:metamorphis/src/domain/_core/domain/repository.dart' as rep;
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/domain/global_enumerator/repositories/global_enumerator_repository.dart';
import 'package:metamorphis/src/infrastructure/data/entity/models/entity_model.dart';
import 'package:metamorphis/src/infrastructure/data/global_enumerator/model/global_enumerator_model.dart';

class GlobalEnumeratorRepositoryImpl implements GlobalEnumeratorRepository {
  final _firestore = FirebaseFirestore.instance;
  final _enumeratorCollection = 'global_enumerators';
  final _entityCollection = 'entities';

  @override
  Future<void> delete(GlobalEnumerator enumerator) async {
    try {
      final id = enumerator.id;
      final batch = _firestore.batch();
      final enumeratorDoc = _firestore
          .collection(_enumeratorCollection)
          .doc(id);
      for (final entity in enumerator.entities) {
        entity.removeEnumerator(enumerator);
        final entityDoc = _firestore
            .collection(_entityCollection)
            .doc(entity.id);
        final entityModel = EntityModel.fromEntity(entity);
        batch.set(entityDoc, entityModel.toMap());
      }
      batch.delete(enumeratorDoc);
      await batch.commit();
    } on FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.delete',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível remover a entidade',
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.delete',
      );
    }
  }

  @override
  Future<List<GlobalEnumerator>> filter(rep.PaginateParams params) async {
    try {
      final result = await _firestore
          .collection(_enumeratorCollection)
          .where(params.filterBy ?? '', isEqualTo: params.filterValue)
          .get();
      final models = result.docs.map((e) {
        return GlobalEnumeratorModel.fromMap(e.data());
      }).toList();
      return models;
    } on FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.filter',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar as entidades',
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.paginate',
      );
    }
  }

  @override
  Future<GlobalEnumerator> getById(String id) async {
    try {
      final result = await _firestore
          .collection(_enumeratorCollection)
          .doc(id)
          .get();
      final data = result.data() ?? {};
      final models = GlobalEnumeratorModel.fromMap(data);
      return models;
    } on FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.getById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar a entidade',
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.getById',
      );
    }
  }

  @override
  Future<rep.Page<GlobalEnumerator>> paginate(rep.Filter filter) async {
    throw UnimplementedError();
  }

  @override
  Future<GlobalEnumerator> save(GlobalEnumerator enumerator) async {
    try {
      final id = enumerator.id;
      final batch = _firestore.batch();
      final enumeratorDoc = _firestore
          .collection(_enumeratorCollection)
          .doc(id);
      for (final entity in enumerator.entities) {
        entity.updateEnumerator(enumerator);
        final entityDoc = _firestore
            .collection(_entityCollection)
            .doc(entity.id);
        final entityModel = EntityModel.fromEntity(entity);
        batch.set(entityDoc, entityModel.toMap());
      }
      final enumeratorModel = GlobalEnumeratorModel.fromEntity(enumerator);
      batch.set(enumeratorDoc, enumeratorModel.toMap());
      await batch.commit();
      return enumerator;
    } on FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a entidade',
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.save',
      );
    }
  }

  @override
  Future<GlobalEnumerator> update(GlobalEnumerator enumerator) async {
    try {
      final id = enumerator.id;
      final batch = _firestore.batch();
      final enumeratorDoc = _firestore
          .collection(_enumeratorCollection)
          .doc(id);
      for (final entity in enumerator.entities) {
        entity.updateEnumerator(enumerator);
        final entityDoc = _firestore
            .collection(_entityCollection)
            .doc(entity.id);
        final entityModel = EntityModel.fromEntity(entity);
        batch.set(entityDoc, entityModel.toMap());
      }
      final enumeratorModel = GlobalEnumeratorModel.fromEntity(enumerator);
      batch.set(enumeratorDoc, enumeratorModel.toMap());
      await batch.commit();
      return enumerator;
    } on FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a entidade',
        trace: s.toString(),
        context: 'GlobalEnumeratorRepositoryImpl.update',
      );
    }
  }
}
