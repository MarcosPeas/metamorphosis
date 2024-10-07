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

  factory ApplicationModel.fromMap(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isMicroservice: json['isMicroservice'],
      projectId: json['projectId'],
      createdAt: DateTime.parse(json['createdAt']),
      apiOptions: json.containsKey('apiOptions')
          ? ApiOptionsModel.fromMap(json['apiOptions'])
          : ApiOptions.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'name': super.name,
      'description': super.description,
      'isMicroservice': super.isMicroservice,
      'projectId': super.projectId,
      'createdAt': super.createdAt.toIso8601String(),
      'apiOptions': ApiOptionsModel.fromEntity(apiOptions).toJson(),
    };
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

  factory ApiOptionsModel.fromMap(Map<String, dynamic> json) {
    return ApiOptionsModel(
      apiType: ApiType.fromString(json['apiType'] ?? ''),
      devUrl: json['devUrl'] ?? '',
      prodUrl: json['prodUrl'] ?? '',
      devKey: json['devKey'] ?? '',
      prodKey: json['prodKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apiType': apiType.name,
      'devUrl': devUrl,
      'prodUrl': prodUrl,
      'devKey': devKey,
      'prodKey': prodKey,
    };
  }
}
