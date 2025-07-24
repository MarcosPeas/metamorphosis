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
    );
  }

  factory UseCaseModel.fromMap(Map<String, dynamic> json) {
    return UseCaseModel(
      id: json['id'],
      name: json['name'],
      useCaseType: UseCaseType.fromString(json['useCaseType']),
      searchField: json['searchField'],
      orderByField: json['orderByField'],
      isAscending: json['isAscending'],
      entityId: json['entityId'],
      input: DataClassModel.fromMap(json['input']),
      output: DataClassModel.fromMap(json['output']),
    );
  }

  factory UseCaseModel.fromJson(String json) {
    final Map<String, dynamic> map = jsonDecode(json);
    return UseCaseModel.fromMap(map);
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
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
