import 'package:metamorphis/src/domain/_core/domain/id_generator.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';

class GlobalEnumerator {
  late final String id;
  String name;
  String description;
  late String _values;
  late final List<Entity> entities;
  final String applicationId;
  late final DateTime createdAt;

  GlobalEnumerator({
    String? id,
    required this.name,
    required this.description,
    String values = '',
    List<Entity>? entities,
    required this.applicationId,
    DateTime? createdAt,
  }) {
    this.id = id ?? IdGenerator.generateId();
    _values = values;
    this.entities = entities ?? [];
    this.createdAt = createdAt ?? DateTime.now();
  }

  factory GlobalEnumerator.withApplication(Application application) {
    return GlobalEnumerator(
      name: '',
      description: '',
      entities: [],
      applicationId: application.id,
    );
  }

  factory GlobalEnumerator.empty() {
    return GlobalEnumerator(
      name: '',
      description: '',
      entities: [],
      applicationId: '',
    );
  }

  void addValues(String values) {
    String result = values.trim();
    while (result.contains('  ')) {
      result = result.replaceAll('  ', ' ');
    }
    while (result.contains(',,')) {
      result = result.replaceAll(',,', ',');
    }
    if (result.endsWith(',')) {
      result = result.substring(0, result.length - 1);
    }
    if (result.startsWith(',')) {
      result = result.substring(1);
    }
    _values = result;
  }

  String get values => _values;

  bool get requirementsAreCompleted {
    if (name.trim().length < 3) {
      return false;
    }
    if (_values.isEmpty) {
      return false;
    }
    return true;
  }

  GlobalEnumerator copyWith({
    String? name,
    String? description,
    String? values,
    List<Entity>? entities,
  }) {
    return GlobalEnumerator(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      values: values ?? _values,
      entities: entities ?? this.entities,
      applicationId: applicationId,
    );
  }

  GlobalEnumerator clone() => copyWith();
}
