import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';

class EntityRuleModel extends EntityRule {
  EntityRuleModel({
    required super.id,
    required super.errorMessage,
    required super.entityId,
  });

  factory EntityRuleModel.fromEntity(EntityRule application) {
    return EntityRuleModel(
      id: application.id,
      errorMessage: application.errorMessage,
      entityId: application.entityId,
    );
  }

  factory EntityRuleModel.fromMap(Map<String, dynamic> json) {
    return EntityRuleModel(
      id: json['id'],
      errorMessage: json['errorMessage'],
      entityId: json['entityId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'errorMessage': errorMessage,
      'entityId': entityId,
    };
  }
}
