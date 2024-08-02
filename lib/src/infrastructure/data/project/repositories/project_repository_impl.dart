import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
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
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar o projeto',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<List<Project>> getByUser(String userId) async {
    try {
      final result = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: userId)
          .get();
      return result.docs.map((e) => ProjectModel.fromMap(e.data())).toList();
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível encontrar os projetos',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<Project> save(Project project) async {
    try {
      final doc = _firestore.collection(collection).doc(project.id);
      final projectModel = ProjectModel.fromEntity(project);
      await doc.set(projectModel.toJson());
      return projectModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar o projeto',
        trace: s.toString(),
      );
    }
  }

  @override
  Future<Project> update(Project project) async {
    try {
      final doc = _firestore.collection(collection).doc(project.id);
      final projectModel = ProjectModel.fromEntity(project);
      await doc.update(projectModel.toJson());
      return projectModel;
    } on auth.FirebaseAuthException catch (e, s) {
      throw DomainException(
        message: e.code,
        trace: s.toString(),
      );
    } catch (e, s) {
      throw DomainException(
        message: 'Não foi possível salvar o projeto',
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
        message: 'Não foi possível remover o projeto',
        trace: s.toString(),
      );
    }
  }
}
