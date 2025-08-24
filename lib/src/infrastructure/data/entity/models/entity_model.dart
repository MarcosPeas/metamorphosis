import 'dart:convert';

import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/data/entity_rule/models/entity_rule_model.dart';
import 'package:metamorphis/src/infrastructure/data/global_enumerator/model/global_enumerator_model.dart';
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
    required super.globalEnumerators,
    required super.child,
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
      globalEnumerators: entity.globalEnumerators,
      child: entity.child,
    );
  }

  factory EntityModel.fromShortMap(Map<String, dynamic> map) {
    final valueObjects = <ValueObject>[];
    final useCases = <UseCase>[];
    final entityRules = <EntityRule>[];
    final references = <Reference>[];
    if (map['valueObjects'] != null) {
      map['valueObjects'].forEach((map) {
        valueObjects.add(ValueObjectModel.fromMap(map));
      });
    }
    if (map['useCases'] != null) {
      map['useCases'].forEach((map) {
        useCases.add(UseCaseModel.fromMap(map));
      });
    }
    if (map['entityRules'] != null) {
      map['entityRules'].forEach((map) {
        entityRules.add(EntityRuleModel.fromMap(map));
      });
    }
    if (map['references'] != null) {
      map['references'].forEach((map) {
        references.add(ReferenceModel.fromMap(map));
      });
    }
    Entity? child;
    if (map['child'] != null) {
      child = EntityModel.fromShortMap(map['child']);
    }
    return EntityModel(
      id: map['id'],
      name: map['name'],
      applicationId: map['applicationId'],
      valueObjects: valueObjects,
      useCases: useCases,
      entityRules: entityRules,
      references: references,
      globalEnumerators: [],
      child: child,
    );
  }

  factory EntityModel.fromMap(Map<String, dynamic> map) {
    final valueObjects = <ValueObject>[];
    final useCases = <UseCase>[];
    final entityRules = <EntityRule>[];
    final references = <Reference>[];
    final globalEnumerators = <EntityGlobalEnumerator>[];
    if (map['valueObjects'] != null) {
      map['valueObjects'].forEach((map) {
        valueObjects.add(ValueObjectModel.fromMap(map));
      });
    }
    if (map['useCases'] != null) {
      map['useCases'].forEach((map) {
        useCases.add(UseCaseModel.fromMap(map));
      });
    }
    if (map['entityRules'] != null) {
      map['entityRules'].forEach((map) {
        entityRules.add(EntityRuleModel.fromMap(map));
      });
    }
    if (map['references'] != null) {
      map['references'].forEach((map) {
        references.add(ReferenceModel.fromMap(map));
      });
    }
    if (map['globalEnumerators'] != null) {
      map['globalEnumerators'].forEach((item) {
        globalEnumerators.add(EntityGlobalEnumeratorModel.fromMap(item));
      });
    }
    Entity? child;
    if (map['child'] != null) {
      child = EntityModel.fromMap(map['child']);
    }
    return EntityModel(
      id: map['id'],
      name: map['name'],
      applicationId: map['applicationId'],
      valueObjects: valueObjects,
      useCases: useCases,
      entityRules: entityRules,
      references: references,
      globalEnumerators: globalEnumerators,
      child: child,
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
    EntityModel? child;
    if (this.child != null) {
      child = EntityModel.fromEntity(this.child!);
    }
    return {
      'id': id,
      'name': name,
      'applicationId': applicationId,
      'valueObjects': valueObjectsModel,
      'useCases': useCasesModel,
      'entityRules': entityRulesModel,
      'references': referencesModel,
      'globalEnumerators': globalEnumerators.map((enumerator) {
        return EntityGlobalEnumeratorModel.fromEntity(enumerator).toMap();
      }).toList(),
      'child': child?.toMap(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}

class EntityGlobalEnumeratorModel extends EntityGlobalEnumerator {
  EntityGlobalEnumeratorModel({required super.name, required super.enumerator});

  factory EntityGlobalEnumeratorModel.fromEntity(
    EntityGlobalEnumerator entityGlobalEnumerator,
  ) {
    return EntityGlobalEnumeratorModel(
      name: entityGlobalEnumerator.name,
      enumerator: entityGlobalEnumerator.enumerator,
    );
  }

  factory EntityGlobalEnumeratorModel.fromMap(Map<String, dynamic> map) {
    return EntityGlobalEnumeratorModel(
      name: map['name'],
      enumerator: GlobalEnumeratorModel.fromShortMap(map['enumerator']),
    );
  }

  factory EntityGlobalEnumeratorModel.fromJson(String json) {
    return EntityGlobalEnumeratorModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'enumerator': GlobalEnumeratorModel.fromEntity(enumerator!).toShortMap(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
