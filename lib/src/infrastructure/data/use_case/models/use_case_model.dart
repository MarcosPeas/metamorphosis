import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';

class UseCaseModel extends UseCase {
  UseCaseModel({
    required super.id,
    required super.name,
    required super.useCaseType,
    super.searchField = '',
    super.orderByField = '',
    super.isAscending = true,
    required super.entityId,
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'useCaseType': useCaseType.name,
      'searchField': searchField,
      'orderByField': orderByField,
      'isAscending': isAscending,
      'entityId': entityId,
    };
  }
}
