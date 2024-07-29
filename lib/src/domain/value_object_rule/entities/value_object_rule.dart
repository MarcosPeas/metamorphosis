import 'package:uuid/uuid.dart';

class ValueObjectRule {
  late final String id;
  final String errorMessage;
  final String valueObjectId;

  ValueObjectRule({
    String? id,
    required this.errorMessage,
    required this.valueObjectId,
  }) {
    {
      this.id = id ?? const Uuid().v4();
    }
  }
}
