import 'dart:developer';

import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
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
  Entity? parent;

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
    this.parent,
  }) {
    this.id = id ?? const Uuid().v7();
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
    _child?.parent = this;
  }

  String get name {
    return _child?.name ?? _name;
  }

  String get thisName {
    return _name;
  }

  void changeName(String value, int version) {
    if (!_usedInSchemeGeneration) {
      log('changed name from $_name to $value');
      _name = value;
      return;
    }
    final child = _makeChild(version);
    child.changeName(value, version);
  }

  void changeToUsedInSchemeGeneration() {
    _usedInSchemeGeneration = true;
    _child?.changeToUsedInSchemeGeneration();
    for (final vo in valueObjects) {
      vo.changeToUsedInSchemeGeneration();
    }
  }

  void changeValueObject(ValueObject valueObject, int version) {
    if (_usedInSchemeGeneration) {
      final child = _makeChild(version);
      child.changeValueObject(valueObject, version);
      return;
    }
    log('changed valueObject with version $version');
    final index = valueObjects.indexWhere((vo) => vo.id == valueObject.id);
    if (index >= 0) {
      valueObjects[index] = valueObject.copyWith();
      return;
    }
    valueObjects.add(valueObject.copyWith());
  }

  void removeValueObject(ValueObject valueObject, int version) {
    if (_usedInSchemeGeneration) {
      final child = _makeChild(version);
      child.removeValueObject(valueObject, version);
      return;
    }
    log('remove valueObject with version $version');
    valueObjects.removeWhere((item) => item.id == valueObject.id);
  }

  Entity _makeChild(int version) {
    _child ??= Entity(
      id: id,
      name: name,
      applicationId: applicationId,
      useCases: useCases.map((item) => item.copyWith()).toList(),
      entityRules: entityRules.map((item) => item.copyWith()).toList(),
      schemeStatus: SchemeStatus.updated,
      usedInSchemeGeneration: false,
      valueObjects: valueObjects.map((item) => item.copyWith()).toList(),
      globalEnumerators: globalEnumerators
          .map((item) => item.copyWith())
          .toList(),
      references: references.map((item) => item.copyWith()).toList(),
      version: version,
      child: null,
      parent: this,
    );
    return _child!;
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
    Entity? parent,
    Entity? child,
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
      child: child ?? this.child?.copyWith(),
      schemeStatus: schemeStatus ?? _schemeStatus,
      version: version ?? _version,
      usedInSchemeGeneration: usedInSchemeGeneration ?? _usedInSchemeGeneration,
      parent: parent ?? this.parent?.copyWith(),
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

  Entity get getDeth {
    return _child == null ? this : _child!.getDeth;
  }

  bool hasChild() => child != null;

  void delete() {
    if (_child != null) {
      _child!.delete();
      return;
    }
    _child = copyWith(
      version: _version,
      references: [],
      name: null,
      globalEnumerators: [],
      valueObjects: [],
      usedInSchemeGeneration: false,
      schemeStatus: SchemeStatus.deleted,
      parent: parent,
    );
  }

  bool get wasDeleted {
    if (schemeStatus == SchemeStatus.deleted) {
      return true;
    }
    return _child?.wasDeleted ?? false;
  }

  List<ModifiedField> getModifiers() {
    final List<ModifiedField> modifieds = [];
    final ofParent = parent!.valueObjects;
    final valueObjects = this.valueObjects.where((item) {
      return ofParent.any((op) {
        return op.id == item.id && op.name == item.name && op.type == item.type;
      });
    }).toList();
    for (final vo in valueObjects) {
      final affected = ofParent.where((item) => item.id == vo.id).firstOrNull;
      if (affected != null) {
        if (affected.type != vo.type) {
          modifieds.add(ModifiedField.modifyType(vo));
        } else if (affected.name != vo.name) {
          modifieds.add(ModifiedField.modifyName(vo));
        }
      } else {
        modifieds.add(ModifiedField.add(vo));
      }
    }
    for (final vo in ofParent) {
      if (!valueObjects.any((v) => v.id == vo.id)) {
        modifieds.add(ModifiedField.remove(vo));
      }
    }
    return modifieds;
  }

  void addRule(ValueObjectRule rule, ValueObject valueObject) {
    final index = valueObjects.indexWhere((vo) => vo.id == valueObject.id);
    if (index >= 0) {
      valueObjects[index].addNewRule(rule);
    }
    Entity? child = this.child;
    Entity? parent = this.parent;
    while (child != null) {
      final index = child.valueObjects.indexWhere(
        (vo) => vo.id == valueObject.id,
      );
      if (index >= 0) {
        child.valueObjects[index].addNewRule(rule);
      }
      child = child.child;
    }
    while (parent != null) {
      final index = parent.valueObjects.indexWhere(
        (vo) => vo.id == valueObject.id,
      );
      if (index >= 0) {
        parent.valueObjects[index].addNewRule(rule);
      }
      parent = parent.parent;
    }
  }

  void removeRule(ValueObjectRule rule, ValueObject valueObject) {
    final index = valueObjects.indexWhere((vo) => vo.id == valueObject.id);
    if (index >= 0) {
      valueObjects[index].removeRule(rule);
    }
    Entity? child = this.child;
    Entity? parent = this.parent;
    while (child != null) {
      final index = child.valueObjects.indexWhere(
        (vo) => vo.id == valueObject.id,
      );
      if (index >= 0) {
        child.valueObjects[index].removeRule(rule);
      }
      child = child.child;
    }
    while (parent != null) {
      final index = parent.valueObjects.indexWhere(
        (vo) => vo.id == valueObject.id,
      );
      if (index >= 0) {
        parent.valueObjects[index].removeRule(rule);
      }
      parent = parent.parent;
    }
  }

  void updateRule(ValueObjectRule rule, ValueObject valueObject) {
    final index = valueObjects.indexWhere((vo) => vo.id == valueObject.id);
    if (index >= 0) {
      valueObjects[index].updateRule(rule);
    }
    Entity? child = this.child;
    Entity? parent = this.parent;
    while (child != null) {
      final index = child.valueObjects.indexWhere(
        (vo) => vo.id == valueObject.id,
      );
      if (index >= 0) {
        child.valueObjects[index].updateRule(rule);
      }
      child = child.child;
    }
    while (parent != null) {
      final index = parent.valueObjects.indexWhere(
        (vo) => vo.id == valueObject.id,
      );
      if (index >= 0) {
        parent.valueObjects[index].updateRule(rule);
      }
      parent = parent.parent;
    }
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
