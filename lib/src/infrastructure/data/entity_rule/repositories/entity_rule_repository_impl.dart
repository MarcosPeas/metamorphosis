import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/entity_rule/repositories/entity_rule_repository.dart';
import 'package:metamorphis/src/infrastructure/data/entity_rule/models/entity_rule_model.dart';

class EntityRuleRepositoryImpl implements EntityRuleRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'entityRules';

  @override
  Future<EntityRule> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return EntityRuleModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRuleRepositoryImpl.getById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar a regra da entidade',
        trace: s.toString(),
        context: 'EntityRuleRepositoryImpl.getById',
      );
    }
  }

  @override
  Future<List<EntityRule>> filter(PaginateParams params) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where(params.filterBy ?? '', isEqualTo: params.filterValue)
          .get();
      return result.docs
          .map((e) => EntityRuleModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRuleRepositoryImpl.getByEntity',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar as aplicações',
        trace: s.toString(),
        context: 'EntityRuleRepositoryImpl.getByEntity',
      );
    }
  }

  @override
  Future<EntityRule> save(EntityRule entityRule) async {
    try {
      final doc = _firestore.collection(collection).doc(entityRule.id);
      final entityRuleModel = EntityRuleModel.fromEntity(entityRule);
      await doc.set(entityRuleModel.toMap());
      return entityRuleModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRuleRepositoryImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a regra da entidade',
        trace: s.toString(),
        context: 'EntityRuleRepositoryImpl.save',
      );
    }
  }

  @override
  Future<EntityRule> update(EntityRule entityRule) async {
    try {
      final doc = _firestore.collection(collection).doc(entityRule.id);
      final entityRuleModel = EntityRuleModel.fromEntity(entityRule);
      await doc.update(entityRuleModel.toMap());
      return entityRuleModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRuleRepositoryImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a regra da entidade',
        trace: s.toString(),
        context: 'EntityRuleRepositoryImpl.update',
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
        context: 'EntityRuleRepositoryImpl.delete',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível remover a regra da entidade',
        trace: s.toString(),
        context: 'EntityRuleRepositoryImpl.delete',
      );
    }
  }

  @override
  Future<Page<EntityRule>> paginate(Filter filter) {
    // TODO: implement paginate
    throw UnimplementedError();
  }
}
