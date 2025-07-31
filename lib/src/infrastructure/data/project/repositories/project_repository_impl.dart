import 'package:cloud_firestore/cloud_firestore.dart' hide Filter;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:metamorphis/src/domain/_core/domain/repository.dart';
import 'package:metamorphis/src/domain/_core/exception/domain_exception.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:metamorphis/src/domain/project/repositories/project_repository.dart';
import 'package:metamorphis/src/infrastructure/data/project/models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final _firestore = FirebaseFirestore.instance;
  final collection = 'projects';

  @override
  Future<Project> getById(String id) async {
    try {
      final result = await _firestore.collection(collection).doc(id).get();
      final data = result.data() ?? {};
      return ProjectModel.fromMap(data);
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ProjectRepositoryImpl.getById',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar o projeto',
        trace: s.toString(),
        context: 'ProjectRepositoryImpl.getById',
      );
    }
  }

  @override
  Future<List<Project>> filter(PaginateParams params) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where(params.filterBy ?? '', isEqualTo: params.filterValue)
          .get();
      return result.docs.map((e) => ProjectModel.fromMap(e.data())).toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ProjectRepositoryImpl.getByUser',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível encontrar os projetos',
        trace: s.toString(),
        context: 'ProjectRepositoryImpl.getByUser',
      );
    }
  }

  @override
  Future<Project> save(Project project) async {
    try {
      final doc = _firestore.collection(collection).doc(project.id);
      final projectModel = ProjectModel.fromEntity(project);
      await doc.set(projectModel.toMap());
      return projectModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ProjectRepositoryImpl.save',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar o projeto',
        trace: s.toString(),
        context: 'ProjectRepositoryImpl.save',
      );
    }
  }

  @override
  Future<Project> update(Project project) async {
    try {
      final doc = _firestore.collection(collection).doc(project.id);
      final projectModel = ProjectModel.fromEntity(project);
      await doc.update(projectModel.toMap());
      return projectModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException.of(
        message: e.code,
        trace: s.toString(),
        context: 'ProjectRepositoryImpl.update',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível salvar o projeto',
        trace: s.toString(),
        context: 'ProjectRepositoryImpl.update',
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
        context: 'ProjectRepositoryImpl.delete',
      );
    } catch (e, s) {
      throw DomainException.of(
        message: 'Não foi possível remover o projeto',
        trace: s.toString(),
        context: 'ProjectRepositoryImpl.delete',
      );
    }
  }

  @override
  Future<Page<Project>> paginate(Filter filter) {
    // TODO: implement paginate
    throw UnimplementedError();
  }
}
