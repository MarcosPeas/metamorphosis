import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/infrastructure/data/use_case/models/use_case_model.dart';
import 'package:metamorphis/src/infrastructure/data/value_object/models/value_object_model.dart';

import '../../../../domain/use_case/entities/use_case.dart';

class EntityModel extends Entity {
  EntityModel({
    required super.id,
    required super.name,
    required super.boundedContextId,
    super.valueObjects,
    super.useCases,
  });

  factory EntityModel.fromEntity(Entity entity) {
    return EntityModel(
      id: entity.id,
      name: entity.name,
      boundedContextId: entity.boundedContextId,
      valueObjects: entity.valueObjects,
      useCases: entity.useCases,
    );
  }

  factory EntityModel.fromMap(Map<String, dynamic> json) {
    final valueObjects = <ValueObject>[];
    final useCases = <UseCase>[];
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
    return EntityModel(
      id: json['id'],
      name: json['name'],
      boundedContextId: json['boundedContextId'],
      valueObjects: valueObjects,
      useCases: useCases,
    );
  }

  Map<String, dynamic> toJson() {
    final valueObjectsModel = valueObjects.map((valueObject) {
      return ValueObjectModel.fromValueObject(valueObject).toMap();
    }).toList();
    final useCasesModel = this.useCases.map((useCase) {
      return UseCaseModel.fromEntity(useCase).toJson();
    }).toList();
    return {
      'id': id,
      'name': name,
      'boundedContextId': boundedContextId,
      'valueObjects': valueObjectsModel,
      'useCases': useCasesModel,
    };
  }
}
