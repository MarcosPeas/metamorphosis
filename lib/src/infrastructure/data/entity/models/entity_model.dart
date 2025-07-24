import 'package:metamorphis/src/domain/composition/entities/composition.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/data/composition/models/composition_model.dart';
import 'package:metamorphis/src/infrastructure/data/entity_rule/models/entity_rule_model.dart';
import 'package:metamorphis/src/infrastructure/data/use_case/models/use_case_model.dart';
import 'package:metamorphis/src/infrastructure/data/value_object/models/value_object_model.dart';

class EntityModel extends Entity {
  EntityModel({
    required super.id,
    required super.name,
    required super.applicationId,
    required super.valueObjects,
    required super.useCases,
    required super.entityRules,
    required super.compositions,
  });

  factory EntityModel.fromEntity(Entity entity) {
    return EntityModel(
      id: entity.id,
      name: entity.name,
      applicationId: entity.applicationId,
      valueObjects: entity.valueObjects,
      useCases: entity.useCases,
      entityRules: entity.entityRules,
      compositions: entity.compositions,
    );
  }

  factory EntityModel.fromMap(Map<String, dynamic> json) {
    final valueObjects = <ValueObject>[];
    final useCases = <UseCase>[];
    final entityRules = <EntityRule>[];
    final references = <Reference>[];
    if (json['valueObjects'] != null) {
      json['valueObjects'].forEach((valueObject) {
        valueObjects.add(ValueObjectModel.fromMap(valueObject));
      });
    }
    if (json['useCases'] != null) {
      json['useCases'].forEach((useCase) {
        useCases.add(UseCaseModel.fromMap(useCase));
      });
    }
    if (json['entityRules'] != null) {
      json['entityRules'].forEach((entityRule) {
        entityRules.add(EntityRuleModel.fromMap(entityRule));
      });
    }
    if (json['references'] != null) {
      json['references'].forEach((reference) {
        references.add(ReferenceModel.fromMap(reference));
      });
    }
    return EntityModel(
      id: json['id'],
      name: json['name'],
      applicationId: json['applicationId'],
      valueObjects: valueObjects,
      useCases: useCases,
      entityRules: entityRules,
      compositions: references,
    );
  }

  Map<String, dynamic> toJson() {
    final valueObjectsModel = valueObjects.map((valueObject) {
      return ValueObjectModel.fromValueObject(valueObject).toMap();
    }).toList();
    final useCasesModel = useCases.map((useCase) {
      return UseCaseModel.fromEntity(useCase).toMap();
    }).toList();
    final entityRulesModel = entityRules.map((entityRule) {
      return EntityRuleModel.fromEntity(entityRule).toJson();
    }).toList();
    final compositionsModel = compositions.map((entityList) {
      return ReferenceModel.fromEntity(entityList).toMap();
    }).toList();
    return {
      'id': id,
      'name': name,
      'applicationId': applicationId,
      'valueObjects': valueObjectsModel,
      'useCases': useCasesModel,
      'entityRules': entityRulesModel,
      'compositions': compositionsModel,
    };
  }
}
