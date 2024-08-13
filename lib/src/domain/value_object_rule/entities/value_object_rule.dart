import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:uuid/uuid.dart';

class ValueObjectRule {
  late final String id;
  final String errorMessage;
  final String valueObjectId;
  late final List<ValueObjectGroupCondition> groupConditions;

  ValueObjectRule({
    String? id,
    required this.errorMessage,
    required this.valueObjectId,
    List<ValueObjectGroupCondition>? groupConditions,
  }) {
    {
      this.id = id ?? const Uuid().v4();
      this.groupConditions = groupConditions ?? [];
    }
  }
}
