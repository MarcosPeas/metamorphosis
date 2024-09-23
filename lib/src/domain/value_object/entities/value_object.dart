import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:uuid/uuid.dart';

class ValueObject {
  late final String id;
  String name;
  String type;
  bool isNullable;
  bool isUnique;
  final String entityId;
  late final List<ValueObjectRule> rules;

  ValueObject({
    String? id,
    required this.name,
    required this.type,
    required this.isNullable,
    required this.entityId,
    List<ValueObjectRule>? rules,
    required this.isUnique,
  }) {
    {
      this.id = id ?? const Uuid().v4();
      this.rules = rules ?? [];
    }
  }

  void addRule(ValueObjectRule rule) {
    rules.add(rule);
  }

  void removeRule(ValueObjectRule rule) {
    rules.remove(rule);
  }

  bool ignoreRules() {
    if (rules.isEmpty) {
      return true;
    }
    final mRules = [...rules];
    mRules.removeWhere((r) => r.groupConditions.isEmpty);
    if (mRules.isEmpty) {
      return true;
    }
    return false;
  }

  void updateRule(ValueObjectRule rule) {
    final index = rules.indexWhere((r) => r.id == rule.id);
    if (index != -1) {
      rules[index] = rule;
    }
  }
}
