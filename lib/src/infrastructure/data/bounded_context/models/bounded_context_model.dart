/*import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';

class BoundedContextModel extends BoundedContext {
  BoundedContextModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.enabled,
    required super.applicationId,
  });

  factory BoundedContextModel.fromEntity(BoundedContext application) {
    return BoundedContextModel(
      id: application.id,
      name: application.name,
      enabled: application.enabled,
      applicationId: application.applicationId,
      createdAt: application.createdAt,
    );
  }

  factory BoundedContextModel.fromMap(Map<String, dynamic> json) {
    return BoundedContextModel(
      id: json['id'],
      name: json['name'],
      enabled: json['enabled'],
      applicationId: json['applicationId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': super.id,
      'name': super.name,
      'enabled': super.enabled,
      'applicationId': super.applicationId,
      'createdAt': super.createdAt.toIso8601String(),
    };
  }
}*/
