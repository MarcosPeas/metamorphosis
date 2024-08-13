import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/entities/value_object_rule_condition.dart';
import 'package:metamorphis/src/domain/value_object_rule_condition/repositories/value_object_rule_condition_repository.dart';
import 'package:metamorphis/src/infrastructure/data/value_object_rule_condition/models/value_object_rule_condition_model.dart';

class ValueObjectRuleConditionRepositoryImpl
    implements ValueObjectRuleConditionRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'valueObjectRuleConditions';

  @override
  Future<ValueObjectRuleCondition> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return ValueObjectRuleConditionModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message:
            'Não foi possível encontrar a condição da regra do objeto de valor',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<List<ValueObjectRuleCondition>> getByValueObjectGroupCondition(
    String valueObjectGroupConditionId,
  ) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where(
            'valueObjectGroupConditionId',
            isEqualTo: valueObjectGroupConditionId,
          )
          .get();
      return result.docs
          .map((e) => ValueObjectRuleConditionModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message:
            'Não foi possível encontrar as condições da regra do objeto de valor',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<ValueObjectRuleCondition> save(
      ValueObjectRuleCondition valueObjectRuleCondition) async {
    try {
      final doc =
          _firestore.collection(collection).doc(valueObjectRuleCondition.id);
      final valueObjectRuleConditionModel =
          ValueObjectRuleConditionModel.fromEntity(valueObjectRuleCondition);
      await doc.set(valueObjectRuleConditionModel.toMap());
      return valueObjectRuleConditionModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message:
            'Não foi possível salvar a condição da regra do objeto de valor',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<ValueObjectRuleCondition> update(
      ValueObjectRuleCondition valueObjectRuleCondition) async {
    try {
      final doc =
          _firestore.collection(collection).doc(valueObjectRuleCondition.id);
      final valueObjectRuleConditionModel =
          ValueObjectRuleConditionModel.fromEntity(valueObjectRuleCondition);
      await doc.update(valueObjectRuleConditionModel.toMap());
      return valueObjectRuleConditionModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message:
            'Não foi possível salvar a condição da regra do objeto de valor',
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
        message:
            'Não foi possível remover a condição da regra do objeto de valor',
        trace: s.toString(),
      );
    }
  }
}
