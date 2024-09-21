import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/repositories/value_object_group_condition_repository.dart';
import 'package:metamorphis/src/infrastructure/data/value_object_group_condition/models/value_object_group_condition_model.dart';

class ValueObjectGroupConditionRepositoryImpl
    implements ValueObjectGroupConditionRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'valueObjectGroupConditions';

  @override
  Future<ValueObjectGroupCondition> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return ValueObjectGroupConditionModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ValueObjectGroupConditionRepositoryImpl.getById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível encontrar o grupo de condições do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectGroupConditionRepositoryImpl.getById',
      );
    }
  }

  @override
  Future<ValueObjectGroupCondition> save(
      ValueObjectGroupCondition valueObjectGroupCondition) async {
    try {
      final doc =
          _firestore.collection(collection).doc(valueObjectGroupCondition.id);
      final valueObjectGroupConditionModel =
          ValueObjectGroupConditionModel.fromEntity(valueObjectGroupCondition);
      await doc.set(valueObjectGroupConditionModel.toMap());
      return valueObjectGroupConditionModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ValueObjectGroupConditionRepositoryImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível salvar o grupo de condições do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectGroupConditionRepositoryImpl.save',
      );
    }
  }

  @override
  Future<ValueObjectGroupCondition> update(
      ValueObjectGroupCondition valueObjectGroupCondition) async {
    try {
      final doc =
          _firestore.collection(collection).doc(valueObjectGroupCondition.id);
      final valueObjectGroupConditionModel =
          ValueObjectGroupConditionModel.fromEntity(valueObjectGroupCondition);
      await doc.update(valueObjectGroupConditionModel.toMap());
      return valueObjectGroupConditionModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ValueObjectGroupConditionRepositoryImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível salvar o grupo de condições do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectGroupConditionRepositoryImpl.update',
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
        context: 'ValueObjectGroupConditionRepositoryImpl.delete',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível remover o grupo de condições do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectGroupConditionRepositoryImpl.delete',
      );
    }
  }

  @override
  Future<List<ValueObjectGroupCondition>> getByValueObjectRule(
    String valueObjectRuleId,
  ) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where('valueObjectRuleId', isEqualTo: valueObjectRuleId)
          .get();
      return result.docs
          .map((e) => ValueObjectGroupConditionModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ValueObjectGroupConditionRepositoryImpl.getByValueObjectRule',
      );
    } catch (e, s) {
      throw DomainException.of(
        message:
            'Não foi possível encontrar os grupos de condições do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectGroupConditionRepositoryImpl.getByValueObjectRule',
      );
    }
  }
}
