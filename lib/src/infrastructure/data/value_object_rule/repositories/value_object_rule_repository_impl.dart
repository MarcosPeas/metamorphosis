import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/domain/value_object_rule/repositories/value_object_rule_repository.dart';
import 'package:metamorphis/src/infrastructure/data/value_object_rule/models/value_object_rule_model.dart';

class ValueObjectRuleRepositoryImpl implements ValueObjectRuleRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'valueObjectRules';

  @override
  Future<ValueObjectRule> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return ValueObjectRuleModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ValueObjectRuleRepositoryImpl.getById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar a regra do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectRuleRepositoryImpl.getById',
      );
    }
  }

  @override
  Future<List<ValueObjectRule>> getByValueObject(String valueObjectId) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where('valueObjectId', isEqualTo: valueObjectId)
          .get();
      return result.docs
          .map((e) => ValueObjectRuleModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ValueObjectRuleRepositoryImpl.getByValueObject',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar as regras do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectRuleRepositoryImpl.getByValueObject',
      );
    }
  }

  @override
  Future<ValueObjectRule> save(ValueObjectRule application) async {
    try {
      final doc = _firestore.collection(collection).doc(application.id);
      final applicationModel =
          ValueObjectRuleModel.fromValueObjectRule(application);
      await doc.set(applicationModel.toMap());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ValueObjectRuleRepositoryImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a regra do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectRuleRepositoryImpl.save',
      );
    }
  }

  @override
  Future<ValueObjectRule> update(ValueObjectRule application) async {
    try {
      final doc = _firestore.collection(collection).doc(application.id);
      final applicationModel =
          ValueObjectRuleModel.fromValueObjectRule(application);
      await doc.update(applicationModel.toMap());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ValueObjectRuleRepositoryImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a regra do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectRuleRepositoryImpl.update',
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
        context: 'ValueObjectRuleRepositoryImpl.delete',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível remover a regra do objeto de valor',
        trace: s.toString(),
        context: 'ValueObjectRuleRepositoryImpl.delete',
      );
    }
  }
}
