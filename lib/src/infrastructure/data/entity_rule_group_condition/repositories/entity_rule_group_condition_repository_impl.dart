import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/repositories/entity_rule_group_condition_repository.dart';
import 'package:metamorphis/src/infrastructure/data/entity_rule_group_condition/models/entity_rule_group_condition_model.dart';

class EntityRuleGroupConditionRepositoryImpl
    implements EntityRuleGroupConditionRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'entityRuleGroupConditions';

  @override
  Future<EntityRuleGroupCondition> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return EntityRuleGroupConditionModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRuleGroupConditionRepositoryImpl.getById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível encontrar o grupo de condições da regra da entidade',
        trace: s.toString(),
        context: 'EntityRuleGroupConditionRepositoryImpl.getById',
      );
    }
  }

  @override
  Future<List<EntityRuleGroupCondition>> paginate(PaginateParams params) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where(params.filterBy ?? '', isEqualTo: params.filterValue)
          .get();
      return result.docs
          .map((e) => EntityRuleGroupConditionModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRuleGroupConditionRepositoryImpl.getByEntityRule',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível encontrar os grupo de condições da regra da aplicação',
        trace: s.toString(),
        context: 'EntityRuleGroupConditionRepositoryImpl.getByEntityRule',
      );
    }
  }

  @override
  Future<EntityRuleGroupCondition> save(
    EntityRuleGroupCondition entityRuleGroupCondition,
  ) async {
    try {
      final doc = _firestore
          .collection(collection)
          .doc(entityRuleGroupCondition.id);
      final entityRuleGroupConditionModel =
          EntityRuleGroupConditionModel.fromEntity(entityRuleGroupCondition);
      await doc.set(entityRuleGroupConditionModel.toJson());
      return entityRuleGroupConditionModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRuleGroupConditionRepositoryImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível salvar o grupo de condições da regra da entidade',
        trace: s.toString(),
        context: 'EntityRuleGroupConditionRepositoryImpl.save',
      );
    }
  }

  @override
  Future<EntityRuleGroupCondition> update(
    EntityRuleGroupCondition entityRuleGroupCondition,
  ) async {
    try {
      final doc = _firestore
          .collection(collection)
          .doc(entityRuleGroupCondition.id);
      final entityRuleGroupConditionModel =
          EntityRuleGroupConditionModel.fromEntity(entityRuleGroupCondition);
      await doc.update(entityRuleGroupConditionModel.toJson());
      return entityRuleGroupConditionModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'EntityRuleGroupConditionRepositoryImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível salvar o grupo de condições da regra da entidade',
        trace: s.toString(),
        context: 'EntityRuleGroupConditionRepositoryImpl.update',
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
        context: 'EntityRuleGroupConditionRepositoryImpl.delete',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível remover o grupo de condições da regra da entidade',
        trace: s.toString(),
        context: 'EntityRuleGroupConditionRepositoryImpl.delete',
      );
    }
  }
}
