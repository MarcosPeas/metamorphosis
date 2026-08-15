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

  Entity({
    String? id,
    required String name,
    required this.applicationId,
    List<ValueObject>? valueObjects,
    List<UseCase>? useCases,
    List<EntityRule>? entityRules,
    List<Reference>? references,
    List<EntityGlobalEnumerator>? globalEnumerators,
  }) {
    this.id = id ?? const Uuid().v7();
    _name = name;
    this.valueObjects = valueObjects ?? [];
    this.useCases = useCases ?? [];
    this.entityRules = entityRules ?? [];
    this.references = references ?? [];
    this.globalEnumerators = globalEnumerators ?? [];
  }

  String get name {
    return _name;
  }

  String get thisName {
    return _name;
  }

  void changeName(String value) {
    _name = value;
  }

  void changeValueObject(ValueObject valueObject) {
    final index = valueObjects.indexWhere((vo) => vo.id == valueObject.id);
    if (index >= 0) {
      valueObjects[index] = valueObject;
      return;
    }
    valueObjects.add(valueObject);
  }

  void removeValueObject(ValueObject valueObject) {
    valueObjects.removeWhere((item) => item.id == valueObject.id);
  }

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
      valueObjects:
          valueObjects ??
          this.valueObjects.map((item) => item.copyWith()).toList(),
      useCases: useCases ?? this.useCases,
      entityRules: entityRules ?? this.entityRules,
      references: references ?? this.references,
      globalEnumerators: globalEnumerators ?? this.globalEnumerators,
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

class ModifiedField {
  late final ValueObject valueObject;
  late final ModifiedFieldType type;

  ModifiedField._(this.valueObject, this.type);

  factory ModifiedField.add(ValueObject valueObject) {
    return ModifiedField._(valueObject, ModifiedFieldType.add);
  }

  factory ModifiedField.remove(ValueObject valueObject) {
    return ModifiedField._(valueObject, ModifiedFieldType.remove);
  }

  factory ModifiedField.modifyType(ValueObject valueObject) {
    return ModifiedField._(valueObject, ModifiedFieldType.modifyType);
  }

  factory ModifiedField.modifyName(ValueObject valueObject) {
    return ModifiedField._(valueObject, ModifiedFieldType.modifyName);
  }

  bool get isAdd => type == ModifiedFieldType.add;

  bool get isRemove => type == ModifiedFieldType.remove;

  bool get isModifyType => type == ModifiedFieldType.modifyType;

  bool get isModifyName => type == ModifiedFieldType.modifyName;
}

enum ModifiedFieldType { add, remove, modifyType, modifyName }
