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
  late final List<GlobalEnumerator> globalEnumerators;

  Entity({
    String? id,
    required this.name,
    required this.applicationId,
    List<ValueObject>? valueObjects,
    List<UseCase>? useCases,
    List<EntityRule>? entityRules,
    List<Reference>? references,
    List<GlobalEnumerator>? globalEnumerators,
  }) {
    this.id = id ?? const Uuid().v4();
    this.valueObjects = valueObjects ?? [];
    this.useCases = useCases ?? [];
    this.entityRules = entityRules ?? [];
    this.references = references ?? [];
    this.globalEnumerators = globalEnumerators ?? [];
  }

  bool containsAnyUseCaseByType(UseCaseType type) {
    return useCases.any((useCase) => useCase.useCaseType == type);
  }

  void removeEnumerator(GlobalEnumerator enumerator) {
    globalEnumerators.removeWhere((e) => e.id == enumerator.id);
  }

  void updateEnumerator(GlobalEnumerator enumerator) {
    final index = globalEnumerators.indexWhere((e) => e.id == enumerator.id);
    if (index != -1) {
      globalEnumerators[index] = enumerator;
    } else {
      globalEnumerators.add(enumerator);
    }
  }
}

/*class EntityGlobalEnumerator {
  final String id;
  final String entityId;
  final String globalEnumeratorId;
  final String name;
  final GlobalEnumerator enumerator;

  EntityGlobalEnumerator({
    required this.id,
    required this.entityId,
    required this.globalEnumeratorId,
    required this.name,
    required this.enumerator,
  });
}*/
