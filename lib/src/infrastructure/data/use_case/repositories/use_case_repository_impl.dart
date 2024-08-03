import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/use_case/repositories/use_case_repository.dart';
import 'package:metamorphis/src/infrastructure/data/use_case/models/use_case_model.dart';

class UseCaseRepositoryImpl implements UseCaseRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'useCases';

  @override
  Future<UseCase> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return UseCaseModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar o caso de uso',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<List<UseCase>> getByEntity(String entityId) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where('entityId', isEqualTo: entityId)
          .get();
      return result.docs
          .map((e) => UseCaseModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar os casos de uso',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<UseCase> save(UseCase useCase) async {
    try {
      final doc = _firestore.collection(collection).doc(useCase.id);
      final useCaseModel = UseCaseModel.fromEntity(useCase);
      await doc.set(useCaseModel.toJson());
      return useCaseModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar o caso de uso',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<UseCase> update(UseCase useCase) async {
    try {
      final doc = _firestore.collection(collection).doc(useCase.id);
      final useCaseModel = UseCaseModel.fromEntity(useCase);
      await doc.update(useCaseModel.toJson());
      return useCaseModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar o caso de uso',
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
        message: 'Não foi possível remover o caso de uso',
        trace: s.toString(),
      );
    }
  }
}
