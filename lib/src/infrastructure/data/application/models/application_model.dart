import 'dart:convert';

import 'package:metamorphis/src/domain/application/entities/api_type.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';

class ApplicationModel extends Application {
  ApplicationModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdAt,
    required super.isMicroservice,
    required super.projectId,
    required super.apiOptions,
  });

  factory ApplicationModel.fromEntity(Application application) {
    return ApplicationModel(
      id: application.id,
      name: application.name,
      description: application.description,
      isMicroservice: application.isMicroservice,
      projectId: application.projectId,
      createdAt: application.createdAt,
      apiOptions: application.apiOptions,
    );
  }

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    return ApplicationModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isMicroservice: map['isMicroservice'],
      projectId: map['projectId'],
      createdAt: DateTime.parse(map['createdAt']),
      apiOptions: map.containsKey('apiOptions')
          ? ApiOptionsModel.fromMap(map['apiOptions'])
          : ApiOptions.empty(),
    );
  }

  factory ApplicationModel.fromJson(String json) {
    return ApplicationModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isMicroservice': isMicroservice,
      'projectId': projectId,
      'createdAt': createdAt.toIso8601String(),
      'apiOptions': ApiOptionsModel.fromEntity(apiOptions).toMap(),
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}

class ApiOptionsModel extends ApiOptions {
  ApiOptionsModel({
    required super.apiType,
    required super.devUrl,
    required super.prodUrl,
    required super.devKey,
    required super.prodKey,
  });

  factory ApiOptionsModel.fromEntity(ApiOptions apiOptions) {
    return ApiOptionsModel(
      apiType: apiOptions.apiType,
      devUrl: apiOptions.devUrl,
      prodUrl: apiOptions.prodUrl,
      devKey: apiOptions.devKey,
      prodKey: apiOptions.prodKey,
    );
  }

  factory ApiOptionsModel.fromMap(Map<String, dynamic> map) {
    return ApiOptionsModel(
      apiType: ApiType.fromString(map['apiType'] ?? ''),
      devUrl: map['devUrl'] ?? '',
      prodUrl: map['prodUrl'] ?? '',
      devKey: map['devKey'] ?? '',
      prodKey: map['prodKey'] ?? '',
    );
  }

  factory ApiOptionsModel.fromJson(String json) {
    return ApiOptionsModel.fromMap(jsonDecode(json));
  }

  Map<String, dynamic> toMap() {
    return {
      'apiType': apiType.name,
      'devUrl': devUrl,
      'prodUrl': prodUrl,
      'devKey': devKey,
      'prodKey': prodKey,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}
