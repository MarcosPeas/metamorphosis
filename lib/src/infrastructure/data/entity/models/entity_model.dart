import 'dart:convert';

import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/data/entity_rule/models/entity_rule_model.dart';
import 'package:metamorphis/src/infrastructure/data/reference/models/reference_model.dart';
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
    required super.references,
  });

  factory EntityModel.fromEntity(Entity entity) {
    return EntityModel(
      id: entity.id,
      name: entity.name,
      applicationId: entity.applicationId,
      valueObjects: entity.valueObjects,
      useCases: entity.useCases,
      entityRules: entity.entityRules,
      references: entity.references,
    );
  }

  factory EntityModel.fromMap(Map<String, dynamic> map) {
    final valueObjects = <ValueObject>[];
    final useCases = <UseCase>[];
    final entityRules = <EntityRule>[];
    final references = <Reference>[];
    if (map['valueObjects'] != null) {
      map['valueObjects'].forEach((valueObject) {
        valueObjects.add(ValueObjectModel.fromMap(valueObject));
      });
    }
    if (map['useCases'] != null) {
      map['useCases'].forEach((useCase) {
        useCases.add(UseCaseModel.fromMap(useCase));
      });
    }
    if (map['entityRules'] != null) {
      map['entityRules'].forEach((entityRule) {
        entityRules.add(EntityRuleModel.fromMap(entityRule));
      });
    }
    if (map['references'] != null) {
      map['references'].forEach((reference) {
        references.add(ReferenceModel.fromMap(reference));
      });
    }
    return EntityModel(
      id: map['id'],
      name: map['name'],
      applicationId: map['applicationId'],
      valueObjects: valueObjects,
      useCases: useCases,
      entityRules: entityRules,
      references: references,
    );
  }

  factory EntityModel.fromJson(String json) {
    return EntityModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    final valueObjectsModel = valueObjects.map((valueObject) {
      return ValueObjectModel.fromValueObject(valueObject).toMap();
    }).toList();
    final useCasesModel = useCases.map((useCase) {
      return UseCaseModel.fromEntity(useCase).toMap();
    }).toList();
    final entityRulesModel = entityRules.map((entityRule) {
      return EntityRuleModel.fromEntity(entityRule).toMap();
    }).toList();
    final referencesModel = references.map((entityList) {
      return ReferenceModel.fromEntity(entityList).toMap();
    }).toList();
    return {
      'id': id,
      'name': name,
      'applicationId': applicationId,
      'valueObjects': valueObjectsModel,
      'useCases': useCasesModel,
      'entityRules': entityRulesModel,
      'references': referencesModel,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
