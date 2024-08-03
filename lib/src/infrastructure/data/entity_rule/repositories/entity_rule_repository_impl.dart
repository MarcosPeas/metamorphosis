import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
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
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar a regra da entidade',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<List<EntityRule>> getByEntity(String entityId) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where('entityId', isEqualTo: entityId)
          .get();
      return result.docs
          .map((e) => EntityRuleModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar as aplicações',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<EntityRule> save(EntityRule entityRule) async {
    try {
      final doc = _firestore.collection(collection).doc(entityRule.id);
      final entityRuleModel = EntityRuleModel.fromEntity(entityRule);
      await doc.set(entityRuleModel.toJson());
      return entityRuleModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar a regra da entidade',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<EntityRule> update(EntityRule entityRule) async {
    try {
      final doc = _firestore.collection(collection).doc(entityRule.id);
      final entityRuleModel = EntityRuleModel.fromEntity(entityRule);
      await doc.update(entityRuleModel.toJson());
      return entityRuleModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar a regra da entidade',
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
        message: 'Não foi possível remover a regra da entidade',
        trace: s.toString(),
      );
    }
  }
}
