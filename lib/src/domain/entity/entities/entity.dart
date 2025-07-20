import 'package:metamorphis/src/domain/composition/entities/composition.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/enumerator/entities/enumerator.dart';
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
  late final List<Reference> compositions;
  late final List<Enumerator> enumerators;

  Entity({
    String? id,
    required this.name,
    required this.applicationId,
    List<ValueObject>? valueObjects,
    List<UseCase>? useCases,
    List<EntityRule>? entityRules,
    List<Reference>? compositions,
    List<Enumerator>? enumerators,
  }) {
    this.id = id ?? const Uuid().v4();
    this.valueObjects = valueObjects ?? [];
    this.useCases = useCases ?? [];
    this.entityRules = entityRules ?? [];
    this.compositions = compositions ?? [];
    this.enumerators = enumerators ?? [];
  }

  bool containsAnyUseCaseByType(UseCaseType type) {
    return useCases.any((useCase) => useCase.useCaseType == type);
  }
}
