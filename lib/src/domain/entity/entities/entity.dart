import 'dart:developer';

import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:uuid/uuid.dart';

class Entity {
  late final String id;
  late String _name;
  final String applicationId;
  late final List<ValueObject> valueObjects;
  late final List<UseCase> useCases;
  late final List<EntityRule> entityRules;
  late final List<Reference> references;
  late final List<EntityGlobalEnumerator> globalEnumerators;
  late bool _usedInSchemeGeneration;
  late int _version;
  late SchemeStatus _schemeStatus;
  Entity? _child;

  Entity({
    String? id,
    required String name,
    required this.applicationId,
    List<ValueObject>? valueObjects,
    List<UseCase>? useCases,
    List<EntityRule>? entityRules,
    List<Reference>? references,
    List<EntityGlobalEnumerator>? globalEnumerators,
    int version = 1,
    bool usedInSchemeGeneration = false,
    SchemeStatus schemeStatus = SchemeStatus.created,
    Entity? child,
  }) {
    this.id = id ?? const Uuid().v4();
    _name = name;
    this.valueObjects = valueObjects ?? [];
    this.useCases = useCases ?? [];
    this.entityRules = entityRules ?? [];
    this.references = references ?? [];
    this.globalEnumerators = globalEnumerators ?? [];
    _version = version;
    _schemeStatus = schemeStatus;
    _usedInSchemeGeneration = usedInSchemeGeneration;
    _child = child;
  }

  String get name {
    return _child?.name ?? _name;
  }

  String get thisName {
    return _name;
  }

  set name(String value) {
    if (!_usedInSchemeGeneration) {
      log('changed name from $_name to $value');
      _name = value;
      return;
    }
    _child ??= Entity(
      id: id,
      name: '',
      applicationId: applicationId,
      useCases: [],
      entityRules: [],
      schemeStatus: SchemeStatus.updated,
      usedInSchemeGeneration: false,
      valueObjects: [],
      globalEnumerators: [],
      references: [],
      version: _version + 1,
      child: null,
    );
    _child!.name = value;
  }

  void changeToUsedInSchemeGeneration() {
    _usedInSchemeGeneration = true;
    for (final vo in valueObjects) {
      vo.changeToUsedInSchemeGeneration();
    }
  }

  bool get usedInSchemeGeneration => _usedInSchemeGeneration;

  SchemeStatus get schemeStatus => _schemeStatus;

  Entity? get child => _child;

  Entity copyWith({
    String? name,
    List<ValueObject>? valueObjects,
    List<Reference>? references,
    List<EntityGlobalEnumerator>? globalEnumerators,
    bool? usedInSchemeGeneration,
    int? version,
    SchemeStatus? schemeStatus,
    List<UseCase>? useCases,
    List<EntityRule>? entityRules,
    int? startLongId,
  }) {
    return Entity(
      id: id,
      name: name ?? this.name,
      applicationId: applicationId,
      valueObjects: valueObjects ?? this.valueObjects,
      useCases: useCases ?? this.useCases,
      entityRules: entityRules ?? this.entityRules,
      references: references ?? this.references,
      globalEnumerators: globalEnumerators ?? this.globalEnumerators,
      child: child,
      schemeStatus: schemeStatus ?? _schemeStatus,
      version: version ?? _version,
      usedInSchemeGeneration: usedInSchemeGeneration ?? _usedInSchemeGeneration,
    );
  }

  bool containsAnyUseCaseByType(UseCaseType type) {
    return useCases.any((useCase) => useCase.useCaseType == type);
  }

  void removeEnumerator(GlobalEnumerator enumerator) {
    globalEnumerators.removeWhere((e) => e.enumerator?.id == enumerator.id);
  }

  void updateEnumerator(GlobalEnumerator enumerator) {
    for (int i = 0; i < globalEnumerators.length; i++) {
      if (globalEnumerators[i].enumerator?.id == enumerator.id) {
        globalEnumerators[i].enumerator = enumerator;
      }
    }
  }

  void addEnumerator(EntityGlobalEnumerator enumerator) {
    if (globalEnumerators.any((e) => e.name == enumerator.name)) {
      throw Exception(
        'Enumerator with name ${enumerator.name} already exists.',
      );
    }
    globalEnumerators.add(enumerator);
  }

  bool containsUpdatedAt() {
    return valueObjects.any((vo) {
      return vo.name == 'updatedAt';
    });
  }

  int get version => _version;

  Entity? getByVersion(int version) {
    if (_version == version) {
      return this;
    }
    return child?.getByVersion(version);
  }

  bool hasChild() => child != null;

  void delete() {
    if (_child != null) {
      _child!.delete();
      return;
    }
    _child = copyWith(
      version: _version + 1,
      references: [],
      name: null,
      globalEnumerators: [],
      valueObjects: [],
      usedInSchemeGeneration: false,
      schemeStatus: SchemeStatus.deleted,
    );
  }

  bool get wasDeleted {
    if (schemeStatus == SchemeStatus.deleted) {
      return true;
    }
    return _child?.wasDeleted ?? false;
  }
}

class EntityGlobalEnumerator {
  final String name;
  GlobalEnumerator? enumerator;

  EntityGlobalEnumerator({required this.name, required this.enumerator});

  factory EntityGlobalEnumerator.empty() {
    return EntityGlobalEnumerator(
      name: '',
      enumerator: GlobalEnumerator.empty(),
    );
  }

  EntityGlobalEnumerator copyWith({
    String? name,
    GlobalEnumerator? enumerator,
  }) {
    return EntityGlobalEnumerator(
      name: name ?? this.name,
      enumerator: enumerator ?? this.enumerator,
    );
  }

  bool get requirementsAreCompleted {
    return name.length > 2 && enumerator?.requirementsAreCompleted == true;
  }

  bool isSimilar(EntityGlobalEnumerator other) {
    if (name != other.name) {
      return false;
    }
    return true;
  }
}

enum SchemeStatus {
  created('created'),
  deleted('deleted'),
  updated('updated'),
  none('none');

  final String name;

  const SchemeStatus(this.name);

  static SchemeStatus fromString(String? name) {
    if (name == null) {
      return created;
    }
    switch (name) {
      case 'created':
        return created;
      case 'deleted':
        return deleted;
      case 'none':
        return none;
      default:
        return updated;
    }
  }
}
