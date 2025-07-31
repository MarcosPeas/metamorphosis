import 'dart:convert';

import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/infrastructure/data/data_class/models/data_class_model.dart';

class UseCaseModel extends UseCase {
  UseCaseModel({
    required super.id,
    required super.name,
    required super.useCaseType,
    super.searchField = '',
    super.orderByField = '',
    super.isAscending = true,
    required super.entityId,
    required super.input,
    required super.output,
    required super.jwtRules,
  });

  factory UseCaseModel.fromEntity(UseCase useCase) {
    return UseCaseModel(
      id: useCase.id,
      name: useCase.name,
      useCaseType: useCase.useCaseType,
      searchField: useCase.searchField,
      orderByField: useCase.orderByField,
      isAscending: useCase.isAscending,
      entityId: useCase.entityId,
      input: useCase.input,
      output: useCase.output,
      jwtRules: useCase.jwtRules,
    );
  }

  factory UseCaseModel.fromMap(Map<String, dynamic> map) {
    List<String> jwtRules = [];
    if (map['jwtRules'] != null && map['jwtRules'] is String) {
      final rulesString = map['jwtRules'] as String;
      jwtRules = rulesString.split(',').toList();
    }
    return UseCaseModel(
      id: map['id'],
      name: map['name'],
      useCaseType: UseCaseType.fromString(map['useCaseType']),
      searchField: map['searchField'],
      orderByField: map['orderByField'],
      isAscending: map['isAscending'],
      entityId: map['entityId'],
      input: DataClassModel.fromMap(map['input']),
      output: DataClassModel.fromMap(map['output']),
      jwtRules: jwtRules,
    );
  }

  factory UseCaseModel.fromJson(String json) {
    return UseCaseModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'useCaseType': useCaseType.name,
      'searchField': searchField,
      'orderByField': orderByField,
      'isAscending': isAscending,
      'entityId': entityId,
      'input': DataClassModel.fromEntity(input)?.toMap(),
      'output': DataClassModel.fromEntity(output)?.toMap(),
      'jwtRules': jwtRules.join(','),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
