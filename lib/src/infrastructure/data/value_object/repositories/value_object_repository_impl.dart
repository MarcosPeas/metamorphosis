import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object/repositories/value_object_repository.dart';
import 'package:metamorphis/src/infrastructure/data/value_object/models/value_object_model.dart';

class ValueObjectRepositoryImpl implements ValueObjectRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'valueObjects';

  @override
  Future<ValueObject> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return ValueObjectModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar o objeto de valor',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<List<ValueObject>> getByEntity(String entityId) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where('entityId', isEqualTo: entityId)
          .get();
      return result.docs
          .map((e) => ValueObjectModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar os objetos de valor',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<ValueObject> save(ValueObject application) async {
    try {
      final doc = _firestore.collection(collection).doc(application.id);
      final applicationModel = ValueObjectModel.fromValueObject(application);
      await doc.set(applicationModel.toMap());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar o objeto de valor',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<ValueObject> update(ValueObject valueObject) async {
    try {
      final doc = _firestore.collection(collection).doc(valueObject.id);
      final valueObjectModel = ValueObjectModel.fromValueObject(valueObject);
      await doc.set(valueObjectModel.toMap());
      return valueObjectModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar o objeto de valor',
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
        message: 'Não foi possível remover o objeto de valor',
        trace: s.toString(),
      );
    }
  }
}
