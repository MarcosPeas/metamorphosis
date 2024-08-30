import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:uuid/uuid.dart';

class Entity {
  late final String id;
  final String name;
  final String boundedContextId;
  late final List<ValueObject> valueObjects;
  late final List<UseCase> useCases;
  late final List<EntityRule> entityRules;

  Entity({
    String? id,
    required this.name,
    required this.boundedContextId,
    List<ValueObject>? valueObjects,
    List<UseCase>? useCases,
    List<EntityRule>? entityRules,
  }) {
    {
      this.id = id ?? const Uuid().v4();
      this.valueObjects = valueObjects ?? [];
      this.useCases = useCases ?? [];
      this.entityRules = entityRules ?? [];
    }
  }

  bool containsAnyUseCaseByType(UseCaseType type) {
    return useCases.any((useCase) => useCase.useCaseType == type);
  }
}
