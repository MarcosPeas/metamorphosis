import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/application/repositories/application_repository.dart';
import 'package:metamorphis/src/infrastructure/data/application/models/application_model.dart';

class ApplicationRepositoryImpl implements ApplicationRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'applications';


  @override
  Future<Application> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return ApplicationModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ApplicationRepositoryImpl.getById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar a aplicação',
        trace: s.toString(),
        context: 'ApplicationRepositoryImpl.getById',
      );
    }
  }

  @override
  Future<List<Application>> paginate(PaginateParams params) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where(params.filterBy ?? '', isEqualTo: params.filterValue)
          .get();
      return result.docs
          .map((e) => ApplicationModel.fromMap(e.data()))
          .toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ApplicationRepositoryImpl.paginate',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar as aplicações',
        trace: s.toString(),
        context: 'ApplicationRepositoryImpl.paginate',
      );
    }
  }

  @override
  Future<Application> save(Application application) async {
    try {
      final doc = _firestore.collection(collection).doc(application.id);
      final applicationModel = ApplicationModel.fromEntity(application);
      await doc.set(applicationModel.toJson());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ApplicationRepositoryImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a aplicação',
        trace: s.toString(),
        context: 'ApplicationRepositoryImpl.save',
      );
    }
  }

  @override
  Future<Application> update(Application application) async {
    try {
      final doc = _firestore.collection(collection).doc(application.id);
      final applicationModel = ApplicationModel.fromEntity(application);
      await doc.update(applicationModel.toJson());
      return applicationModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ApplicationRepositoryImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar a aplicação',
        trace: s.toString(),
        context: 'ApplicationRepositoryImpl.update',
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
        context: 'ApplicationRepositoryImpl.delete',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível remover a aplicação',
        trace: s.toString(),
        context: 'ApplicationRepositoryImpl.delete',
      );
    }
  }
}
