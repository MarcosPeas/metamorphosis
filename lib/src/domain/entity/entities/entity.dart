import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:uuid/uuid.dart';

class Entity {
  late final String id;
  final String name;
  final String applicationId;
  late final List<ValueObject> valueObjects;
  late final List<UseCase> useCases;
  late final List<EntityRule> entityRules;
  late final List<Reference> references;
  late final List<EntityGlobalEnumerator> globalEnumerators;
  Entity? child;

  bool isSimilar(Entity other) {
    if (other.name != name) {
      return false;
    }
    if (valueObjects.length != other.valueObjects.length) {
      return false;
    }
    if (globalEnumerators.length != other.globalEnumerators.length) {
      return false;
    }
    if (references.length != other.references.length) {
      return false;
    }
    for(int i = 0; i < valueObjects.length; i++) {
      if (!valueObjects[i].isSimilar(other.valueObjects[i])) {
        return false;
      }
    }
    for(int i = 0; i < globalEnumerators.length; i++) {
      if (!globalEnumerators[i].isSimilar(other.globalEnumerators[i])) {
        return false;
      }
    }
    for(int i = 0; i < references.length; i++) {
      if (!references[i].isSimilar(other.references[i])) {
        return false;
      }
    }
    return true;
  }

  Entity({
    String? id,
    required this.name,
    required this.applicationId,
    List<ValueObject>? valueObjects,
    List<UseCase>? useCases,
    List<EntityRule>? entityRules,
    List<Reference>? references,
    List<EntityGlobalEnumerator>? globalEnumerators,
    this.child,
  }) {
    this.id = id ?? const Uuid().v4();
    this.valueObjects = valueObjects ?? [];
    this.useCases = useCases ?? [];
    this.entityRules = entityRules ?? [];
    this.references = references ?? [];
    this.globalEnumerators = globalEnumerators ?? [];
  }

  Entity copyWith({
    String? name,
    List<ValueObject>? valueObjects,
    List<Reference>? references,
    List<EntityGlobalEnumerator>? globalEnumerators,
  }) {
    return Entity(
      id: id,
      name: name ?? this.name,
      applicationId: applicationId,
      valueObjects: valueObjects ?? this.valueObjects,
      useCases: useCases,
      entityRules: entityRules,
      references: references ?? this.references,
      globalEnumerators: globalEnumerators ?? this.globalEnumerators,
      child: child,
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
