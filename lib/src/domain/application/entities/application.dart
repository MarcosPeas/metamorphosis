import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';
import 'package:uuid/uuid.dart';

import '../../_core/exception/domain_error.dart';
import '../../_core/exception/domain_exception.dart';
import '../value_objects/application_name.dart';
import 'api_type.dart';

class Application {
  late final String id;
  late ApplicationName _name;
  String description;
  bool isMicroservice;
  String projectId;
  late final DateTime createdAt;
  Project? project;
  //List<BoundedContext> contexts = [];
  List<Entity> entities = [];
  final List<DomainError> errors = [];
  ApiOptions apiOptions;

  Application({
    String? id,
    required String name,
    required this.description,
    required this.isMicroservice,
    required this.projectId,
    DateTime? createdAt,
    required this.apiOptions,
  }) {
    {
      this.id = id ?? const Uuid().v7();
      this.createdAt = createdAt ?? DateTime.now();
      _name = ApplicationName(value: name, errors: errors);
      _validate();
    }
  }

  set name(String value) {
    _name = ApplicationName(value: value, errors: errors);
    _validate();
  }

  String get name => _name.value;

  void _validate() {
    if (errors.isNotEmpty) {
      throw DomainException(errors: errors);
    }
  }
}
