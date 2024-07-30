import 'package:uuid/uuid.dart';

class EntityRule {
  late final String id;
  String errorMessage;
  final String entityId;

  EntityRule({
    String? id,
    required this.errorMessage,
    required this.entityId,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}
