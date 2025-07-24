import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/_core/utils/types_utils.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/presenter/home/entity_rules/entity_rules_controller.dart';

class EntityRuleDialog extends StatelessWidget {
  final EntityRulesController controller;
  final bool isFirst;
  final EntityRuleGroupCondition group;
  final store = _EntityDialogRuleStore();

  EntityRuleDialog({
    required this.isFirst,
    required this.controller,
    required this.group,
    super.key,
  });

  bool _validated() {
    final leftField = store.leftField;
    final operator = store.selectedOperator;
    final targetValue = store.targetValue;
    if (leftField == null) return false;
    if (operator == null) return false;
    if (leftField is Reference) {
      if (operator == 'isNotEmpty') return true;
      if (operator == 'isEmpty') return true;
      if (operator != 'isNotEmpty' && operator != 'isEmpty') {
        return targetValue.isNotEmpty;
      }
      if (store.usesValueObjectTarget) {
        return targetValue.isNotEmpty;
      }
    }
    if (leftField is ValueObject) {
      if (store.usesValueObjectTarget) {
        return store.rightField != null;
      } else {
        return targetValue.isNotEmpty;
      }
    }
    return false;
  }

  void _createEntityRule(BuildContext context) {
    final rightField = store.usesValueObjectTarget ? store.rightField : null;
    controller.createEntityRuleCondition(
      group: group,
      logicOperator: store.logicOperator,
      targetValue: store.targetValue,
      comparatorOperator: store.selectedOperator ?? '',
      leftObject: store.leftField,
      rightValueObject: rightField,
    );
    context.pop();
  }

  List<ValueObject> _getAnotherFields() {
    if (store.leftField is ValueObject) {
      final valueObjects = [...controller.entityStore.entity.valueObjects];
      final filtered = valueObjects.where(
        (element) {
          return element != store.leftField &&
              element.type == store.leftField.type;
        },
      );
      return filtered.toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final entity = controller.entityStore.entity;
    return ListenableBuilder(
      listenable: store,
      builder: (_, __) {
        final valueObjects = _getAnotherFields();
        valueObjects.remove(store.leftField);
        return AlertDialog(
          title: const Text('Create an entity rule condition'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!isFirst) ...[
                const Text('Logic Operator'),
                DropdownButton(
                  value: store.logicOperator,
                  isExpanded: true,
                  onChanged: (value) {
                    store.logicOperator = value.toString();
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'AND',
                      child: Text('AND'),
                    ),
                    DropdownMenuItem(
                      value: 'OR',
                      child: Text('OR'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              const Text('Field'),
              DropdownButton(
                value: store.leftField,
                isExpanded: true,
                onChanged: (value) {
                  store.leftField = value;
                  store.selectedOperator = null;
                  store.rightField = null;
                  if (value is ValueObject) {
                    final valueObject = entity.valueObjects.firstWhere(
                      (element) => element == value,
                    );
                    store.operators = TypesUtils.conditionsForEntity(
                      valueObject.type,
                    );
                  } else if (value is Reference) {
                    store.operators = TypesUtils.conditionsForEntity(
                      value.referenceType.name,
                    );
                  }
                },
                items: [
                  for (final valueObject in entity.valueObjects)
                    DropdownMenuItem(
                      value: valueObject,
                      child: Text(valueObject.name),
                    ),
                  for (final composition in entity.references)
                    DropdownMenuItem(
                      value: composition,
                      child: Text(composition.name),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Text('Comparator Operator'),
              const SizedBox(height: 8),
              DropdownButton(
                value: store.selectedOperator,
                isExpanded: true,
                onChanged: (value) {
                  store.selectedOperator = value.toString();
                },
                items: [
                  for (final type in store.operators)
                    DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    ),
                ],
              ),
              if (store.leftField is! Reference) ...[
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Compare with another element'),
                  value: store.usesValueObjectTarget,
                  onChanged: store.leftField != null
                      ? (newValue) {
                          store.usesValueObjectTarget = newValue;
                        }
                      : null,
                ),
                const SizedBox(height: 16),
                if (store.usesValueObjectTarget)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Another field'),
                      DropdownButton(
                        value: store.rightField,
                        isExpanded: true,
                        onChanged: (value) {
                          store.rightField = value;
                        },
                        items: [
                          for (final valueObject in valueObjects)
                            DropdownMenuItem(
                              value: valueObject,
                              child: Text(valueObject.name),
                            ),
                        ],
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: store.targetTextController,
                    onChanged: (value) {
                      store.targetValue = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Target value',
                    ),
                  ),
              ],
              _targetValueToComposition(
                store.leftField,
                store.selectedOperator,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: _validated() ? () => _createEntityRule(context) : null,
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _targetValueToComposition(
    dynamic leftFieldValue,
    String? currentOperator,
  ) {
    if (leftFieldValue is Reference) {
      if (currentOperator != null) {
        if (currentOperator != 'isNotEmpty') {
          if (currentOperator != 'isEmpty') {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: store.targetTextController,
                  onChanged: (value) {
                    store.targetValue = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Target value',
                  ),
                ),
              ],
            );
          }
        }
      }
    }
    return const SizedBox.shrink();
  }
}

class _EntityDialogRuleStore extends ChangeNotifier {
  String _logicOperator = 'AND';
  dynamic _leftField;
  List<String> _operators = [];
  String? _selectedOperator;
  ValueObject? _rightField;
  bool _usesValueObjectTarget = false;
  String _targetValue = '';
  final targetTextController = TextEditingController();

  String get logicOperator => _logicOperator;

  set logicOperator(String value) {
    _logicOperator = value;
    notifyListeners();
  }

  dynamic get leftField => _leftField;

  set leftField(dynamic value) {
    _leftField = value;
    notifyListeners();
  }

  List<String> get operators => _operators;

  set operators(List<String> value) {
    _operators = value;
    notifyListeners();
  }

  String? get selectedOperator => _selectedOperator;

  set selectedOperator(String? value) {
    _selectedOperator = value;
    notifyListeners();
  }

  ValueObject? get rightField => _rightField;

  set rightField(ValueObject? value) {
    _rightField = value;
    notifyListeners();
  }

  bool get usesValueObjectTarget => _usesValueObjectTarget;

  set usesValueObjectTarget(bool value) {
    _usesValueObjectTarget = value;
    notifyListeners();
  }

  String get targetValue => _targetValue;

  set targetValue(String value) {
    _targetValue = value.trim();
    notifyListeners();
  }
}
