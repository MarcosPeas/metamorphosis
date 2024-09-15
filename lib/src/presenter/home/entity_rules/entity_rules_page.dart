import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/_core/utils/types_utils.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';

import 'entity_rules_controller.dart';

class EntityRulesPage extends StatefulWidget {
  const EntityRulesPage({super.key});

  @override
  State<EntityRulesPage> createState() => _EntityRulesPageState();
}

class _EntityRulesPageState extends State<EntityRulesPage> {
  late final EntityRulesController controller;

  @override
  void initState() {
    controller = GetIt.instance.get();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final entityStore = controller.entityStore;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Entity Rules',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: _showDialogCreateEntityRule,
              icon: Icon(
                color: colorScheme.primary,
                Icons.add,
                size: 22,
              ),
            ),
          ],
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: entityStore,
            builder: (context, _) {
              if (entityStore.loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final entity = entityStore.entity;
              if (entity.entityRules.isEmpty) {
                return const Center(
                  child: Text('No entity rules'),
                );
              }
              final entityRules = entity.entityRules;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: entityRules.length,
                itemBuilder: (_, index) {
                  final entityRule = entityRules[index];
                  return _EntityRuleWidget(
                    entityRule: entityRule,
                    controller: controller,
                    onEditTap: () {
                      _showDialogEditEntityRule(entityRule);
                    },
                    onDeleteTap: () {
                      controller.deleteEntityRule(entityRule);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDialogCreateEntityRule() {
    final nameController = TextEditingController();
    final entity = controller.entityStore.entity;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rule for ${entity.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                onSubmitted: (text) {
                  if (text.isEmpty) {
                    return;
                  }
                  context.pop();
                  controller.addEntityRule(nameController.text.trim());
                },
                decoration: const InputDecoration(
                  labelText: 'Error message',
                ),
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
              onPressed: () {
                context.pop();
                controller.addEntityRule(
                  nameController.text.trim(),
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogEditEntityRule(EntityRule entityRule) {
    final nameController = TextEditingController(text: entityRule.errorMessage);
    final entity = controller.entityStore.entity;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edite rule for ${entity.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                onSubmitted: (text) {
                  if (text.isEmpty) {
                    return;
                  }
                  context.pop();
                  controller.editEntityRule(
                    entityRule: entityRule,
                    errorMessage: nameController.text.trim(),
                  );
                },
                decoration: const InputDecoration(
                  labelText: 'Error message',
                ),
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
              onPressed: () {
                context.pop();
                controller.editEntityRule(
                  entityRule: entityRule,
                  errorMessage: nameController.text.trim(),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _EntityRuleWidget extends StatelessWidget {
  final hoverIndex = ValueNotifier(-1);
  final hoverAddRule = ValueNotifier(false);
  final EntityRule entityRule;
  final EntityRulesController controller;
  final void Function() onEditTap;
  final void Function() onDeleteTap;

  _EntityRuleWidget({
    required this.controller,
    required this.entityRule,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final groupsConditions = entityRule.groupConditions;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            entityRule.errorMessage,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 18),
                onPressed: onEditTap,
              ),
              const SizedBox(width: 1),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: 18,
                  color: colorScheme.error,
                ),
                onPressed: onDeleteTap,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: groupsConditions.length,
                itemBuilder: (_, index) {
                  final groupCondition = groupsConditions[index];
                  return ValueListenableBuilder(
                    valueListenable: hoverIndex,
                    builder: (_, __, ___) {
                      final hoverAddRuleGroup = ValueNotifier(false);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (index > 0)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(groupCondition.logicOperator ?? ''),
                            ),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                                bottom: 8,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        onEnter: (_) {
                                          hoverIndex.value = index;
                                        },
                                        onExit: (_) {
                                          hoverIndex.value = -1;
                                        },
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            'Group ${index + 1}',
                                            style:
                                                textTheme.bodyLarge?.copyWith(
                                              color: colorScheme.primary,
                                              decoration:
                                                  hoverIndex.value == index
                                                      ? TextDecoration.underline
                                                      : TextDecoration.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          controller.removeGroupCondition(
                                            groupCondition: groupCondition,
                                            groupsConditions: groupsConditions,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: ValueListenableBuilder(
                                      valueListenable: hoverAddRuleGroup,
                                      builder: (_, __, ___) {
                                        return MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          onEnter: (_) {
                                            hoverAddRuleGroup.value = true;
                                          },
                                          onExit: (_) {
                                            hoverAddRuleGroup.value = false;
                                          },
                                          child: GestureDetector(
                                            onTap: () {
                                              _showDialogCreateEntityRuleCondition(
                                                context: context,
                                                groupCondition: groupCondition,
                                                isFirst: groupCondition
                                                    .conditions.isEmpty,
                                              );
                                            },
                                            child: Text(
                                              'Add condition',
                                              style:
                                                  textTheme.bodySmall?.copyWith(
                                                color: colorScheme.primary,
                                                decoration: hoverAddRuleGroup
                                                        .value
                                                    ? TextDecoration.underline
                                                    : TextDecoration.none,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder(
                valueListenable: hoverAddRule,
                builder: (_, __, ___) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      hoverAddRule.value = true;
                    },
                    onExit: (_) {
                      hoverAddRule.value = false;
                    },
                    child: GestureDetector(
                      onTap: () {
                        _showDialogCreateValueObjectGroupCondition(
                          context: context,
                          rule: entityRule,
                        );
                      },
                      child: Text(
                        'Add conditions group',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          decoration: hoverAddRule.value
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _showDialogCreateValueObjectGroupCondition({
    required EntityRule rule,
    required BuildContext context,
  }) {
    final selectedType = ValueNotifier('AND');
    if (rule.groupConditions.isEmpty) {
      controller.createEntityRuleGroupCondition(
        rule: rule,
        value: selectedType.value,
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a value object group condition'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(rule.errorMessage),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: selectedType,
                builder: (_, operator, __) {
                  return DropdownButton(
                    value: operator,
                    isExpanded: true,
                    onChanged: (value) {
                      selectedType.value = value.toString();
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
                  );
                },
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
              onPressed: () {
                context.pop();
                controller.createEntityRuleGroupCondition(
                  rule: rule,
                  value: selectedType.value,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogCreateEntityRuleCondition({
    required BuildContext context,
    required EntityRuleGroupCondition groupCondition,
    required bool isFirst,
  }) {
    final logicOperator = ValueNotifier('AND');
    final entity = controller.entityStore.entity;
    final leftField = ValueNotifier<ValueObject?>(null);
    final operators = ValueNotifier<List<String>>([]);
    final selectedOperator = ValueNotifier<String?>(null);
    final rightField = ValueNotifier<ValueObject?>(null);
    final usesValueObjectTarget = ValueNotifier(false);
    final targetTextController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Create an entity rule condition'),
          content: ValueListenableBuilder(
            valueListenable: leftField,
            builder: (_, leftFieldValue, __) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isFirst) ...[
                    const Text('Logic Operator'),
                    ValueListenableBuilder(
                      valueListenable: logicOperator,
                      builder: (_, operator, __) {
                        return DropdownButton(
                          value: operator,
                          isExpanded: true,
                          onChanged: (value) {
                            logicOperator.value = value.toString();
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
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  const Text('Field'),
                  DropdownButton(
                    value: leftFieldValue,
                    isExpanded: true,
                    onChanged: (value) {
                      leftField.value = value;
                      final valueObject = entity.valueObjects.firstWhere(
                            (element) => element == value,
                      );
                      selectedOperator.value = null;
                      rightField.value = null;
                      operators.value = TypesUtils.conditionsForEntity(
                        valueObject.type,
                      );
                    },
                    items: [
                      for (final valueObject in entity.valueObjects)
                        DropdownMenuItem(
                          value: valueObject,
                          child: Text(valueObject.name),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Comparator Operator'),
                  const SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: operators,
                    builder: (_, values, __) {
                      return ValueListenableBuilder(
                        valueListenable: selectedOperator,
                        builder: (_, currentOperator, __) {
                          return DropdownButton(
                            value: currentOperator,
                            isExpanded: true,
                            onChanged: (value) {
                              selectedOperator.value = value.toString();
                            },
                            items: [
                              for (final type in values)
                                DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                    valueListenable: usesValueObjectTarget,
                    builder: (_, value, __) {
                      return SwitchListTile(
                        title: const Text('Compare with another value object'),
                        value: value,
                        onChanged: leftFieldValue != null ? (newValue) {
                          usesValueObjectTarget.value = newValue;
                        } : null,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder(
                    valueListenable: usesValueObjectTarget,
                    builder: (_, value, __) {
                      if (value) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Another field'),
                            ValueListenableBuilder(
                              valueListenable: rightField,
                              builder: (_, value, __) {
                                final valueObjects = [...entity.valueObjects];
                                valueObjects.remove(leftField.value);
                                return DropdownButton(
                                  value: value,
                                  isExpanded: true,
                                  onChanged: (value) {
                                    rightField.value = value;
                                  },
                                  items: [
                                    for (final valueObject in valueObjects)
                                      DropdownMenuItem(
                                        value: valueObject,
                                        child: Text(valueObject.name),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      }
                      return TextField(
                        controller: targetTextController,
                        decoration: const InputDecoration(
                          labelText: 'Target value',
                        ),
                      );
                    },
                  ),
                ],
              );
            }
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
/*
class _GroupConditionWidget extends StatelessWidget {
  final EntityRule rule;
  final EntityRulesController controller;

  const _GroupConditionWidget({
    required this.rule,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final groupConditions = rule.groupConditions;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: groupConditions.length,
        itemBuilder: (_, index) {
          final groupCondition = groupConditions[index];
          final hoverAddCondition = ValueNotifier(false);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (index > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(groupCondition.logicOperator ?? '__'),
                ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text('Group ${index + 1}'),
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 18),
                                onPressed: () {
                                  /*controller.removeValueObjectGroupCondition(
                                    rule: rule,
                                    groupCondition: groupCondition,
                                  );*/
                                },
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      _ConditionsWidget(
                        controller: controller,
                        groupCondition: groupCondition,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 24,
                          left: 24,
                          top: 8,
                        ),
                        child: ValueListenableBuilder(
                          valueListenable: hoverAddCondition,
                          builder: (_, __, ___) {
                            return MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (_) {
                                hoverAddCondition.value = true;
                              },
                              onExit: (_) {
                                hoverAddCondition.value = false;
                              },
                              child: GestureDetector(
                                onTap: () {
                                  _showDialogCreateValueObjectConditionWith(
                                    context: context,
                                    groupCondition: groupCondition,
                                    groupIndex: index,
                                    isFirst: groupCondition.conditions.isEmpty,
                                  );
                                },
                                child: Text(
                                  'Add condition',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.primary,
                                    decoration: hoverAddCondition.value
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDialogCreateValueObjectConditionWith({
    required int groupIndex,
    //required ValueObject valueObject,
    required EntityRuleGroupCondition groupCondition,
    required BuildContext context,
    required bool isFirst,
  }) {
    final numbers = [
      'byte/int8',
      'short/int16',
      'int/int32',
      'long/int64',
      'float/float32',
      'double/float64',
    ];
    /*if (valueObject.type == 'String') {
      _showDialogCreateValueObjectConditionWithString(
        groupIndex: groupIndex,
        valueObject: valueObject,
        groupCondition: groupCondition,
        context: context,
        isFirst: isFirst,
      );
    } else if (numbers.contains(valueObject.type)) {
      _showDialogCreateValueObjectConditionWithNumber(
        groupIndex: groupIndex,
        valueObject: valueObject,
        groupCondition: groupCondition,
        context: context,
        isFirst: isFirst,
      );
    } else {*/
    _showDialogCreateValueObjectConditionDefault(
      groupIndex: groupIndex,
      //valueObject: valueObject,
      groupCondition: groupCondition,
      context: context,
      isFirst: isFirst,
    );
    //}
  }

  void _showDialogCreateValueObjectConditionWithString({
    required int groupIndex,
    required ValueObject valueObject,
    required EntityRuleGroupCondition groupCondition,
    required BuildContext context,
    required bool isFirst,
  }) {
    final selectedLogicOperator = ValueNotifier('AND');
    final comparatorOperators = TypesUtils.conditions(
      valueObject.type,
    );
    final selectedComparatorOperator = ValueNotifier(
      comparatorOperators.first,
    );
    final targetValueController = TextEditingController();
    final regexController = TextEditingController();
    final shortOperators = ['is empty', 'is not empty', 'matches'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create a value object condition:\ngroup ${groupIndex + 1}',
          ),
          content: ValueListenableBuilder(
            valueListenable: selectedLogicOperator,
            builder: (_, operator, __) {
              return ValueListenableBuilder(
                valueListenable: selectedComparatorOperator,
                builder: (_, b, __) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(rule.errorMessage),
                      const SizedBox(height: 16),
                      if (!isFirst) const Text('Logic Operator'),
                      if (!isFirst)
                        DropdownButton(
                          value: operator,
                          isExpanded: true,
                          onChanged: (value) {
                            selectedLogicOperator.value = value.toString();
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
                      if (!isFirst) const SizedBox(height: 8),
                      const Text('Comparator Operator'),
                      ValueListenableBuilder(
                        valueListenable: selectedComparatorOperator,
                        builder: (_, operator, __) {
                          return DropdownButton(
                            value: operator,
                            isExpanded: true,
                            onChanged: (value) {
                              selectedComparatorOperator.value =
                                  value.toString();
                            },
                            items: comparatorOperators.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      if (!shortOperators
                          .contains(selectedComparatorOperator.value))
                        const SizedBox(height: 8),
                      if (!shortOperators
                          .contains(selectedComparatorOperator.value))
                        TextField(
                          controller: targetValueController,
                          decoration: const InputDecoration(
                            labelText: 'Target value',
                          ),
                        ),
                      if (selectedComparatorOperator.value == 'matches')
                        const SizedBox(height: 8),
                      if (selectedComparatorOperator.value == 'matches')
                        TextField(
                          controller: regexController,
                          decoration: const InputDecoration(
                            labelText: 'Regex',
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                controller.createEntityRuleCondition(
                  group: groupCondition,
                  logicOperator: selectedLogicOperator.value,
                  comparatorOperator: selectedComparatorOperator.value,
                  targetValue: targetValueController.text.trim(),
                  regex: regexController.text.trim(),
                  leftValueObject: ValueObject(
                      name: 'name',
                      type: 'type',
                      nullable: false,
                      entityId: 'entityId'),
                  rightValueObject: ValueObject(
                      name: 'name',
                      type: 'type',
                      nullable: false,
                      entityId: 'entityId'),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogCreateValueObjectConditionWithNumber({
    required int groupIndex,
    required ValueObject valueObject,
    required EntityRuleGroupCondition groupCondition,
    required BuildContext context,
    required bool isFirst,
  }) {
    final selectedLogicOperator = ValueNotifier('AND');
    final comparatorOperators = TypesUtils.conditions(
      valueObject.type,
    );
    final selectedComparatorOperator = ValueNotifier(
      comparatorOperators.first,
    );
    final targetValueController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create a value object condition:\ngroup ${groupIndex + 1}',
          ),
          content: ValueListenableBuilder(
            valueListenable: selectedLogicOperator,
            builder: (_, operator, __) {
              return ValueListenableBuilder(
                valueListenable: selectedComparatorOperator,
                builder: (_, b, __) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(rule.errorMessage),
                      const SizedBox(height: 16),
                      if (!isFirst) const Text('Logic Operator'),
                      if (!isFirst)
                        DropdownButton(
                          value: operator,
                          isExpanded: true,
                          onChanged: (value) {
                            selectedLogicOperator.value = value.toString();
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
                      if (!isFirst) const SizedBox(height: 8),
                      const Text('Comparator Operator'),
                      ValueListenableBuilder(
                        valueListenable: selectedComparatorOperator,
                        builder: (_, operator, __) {
                          return DropdownButton(
                            value: operator,
                            isExpanded: true,
                            onChanged: (value) {
                              selectedComparatorOperator.value =
                                  value.toString();
                            },
                            items: comparatorOperators.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: targetValueController,
                        decoration: const InputDecoration(
                          labelText: 'Target value',
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                controller.createEntityRuleCondition(
                  group: groupCondition,
                  logicOperator: selectedLogicOperator.value,
                  comparatorOperator: selectedComparatorOperator.value,
                  targetValue: targetValueController.text.trim(),
                  regex: '',
                  leftValueObject: ValueObject(
                      name: 'name',
                      type: 'type',
                      nullable: false,
                      entityId: 'entityId'),
                  rightValueObject: ValueObject(
                      name: 'name',
                      type: 'type',
                      nullable: false,
                      entityId: 'entityId'),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogCreateValueObjectConditionDefault({
    required int groupIndex,
    //required ValueObject valueObject,
    required EntityRuleGroupCondition groupCondition,
    required BuildContext context,
    required bool isFirst,
  }) {
    final selectedLogicOperator = ValueNotifier('AND');
    final comparatorOperators = TypesUtils.conditions(
      'none',
    );
    final selectedComparatorOperator = ValueNotifier('none');
    final targetValueController = TextEditingController();
    final regexController = TextEditingController();
    final shortOperators = ['is empty', 'is not empty', 'matches'];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create a value object condition:\ngroup ${groupIndex + 1}',
          ),
          content: ValueListenableBuilder(
            valueListenable: selectedLogicOperator,
            builder: (_, operator, __) {
              return ValueListenableBuilder(
                valueListenable: selectedComparatorOperator,
                builder: (_, b, __) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(rule.errorMessage),
                      const SizedBox(height: 16),
                      if (!isFirst) const Text('Logic Operator'),
                      if (!isFirst)
                        DropdownButton(
                          value: operator,
                          isExpanded: true,
                          onChanged: (value) {
                            selectedLogicOperator.value = value.toString();
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
                      if (!isFirst) const SizedBox(height: 8),
                      const Text('Comparator Operator'),
                      ValueListenableBuilder(
                        valueListenable: selectedComparatorOperator,
                        builder: (_, operator, __) {
                          return DropdownButton(
                            value: operator,
                            isExpanded: true,
                            onChanged: (value) {
                              selectedComparatorOperator.value =
                                  value.toString();
                            },
                            items: comparatorOperators.map((item) {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                          );
                        },
                      ),
                      if (!shortOperators
                          .contains(selectedComparatorOperator.value))
                        const SizedBox(height: 8),
                      if (!shortOperators
                          .contains(selectedComparatorOperator.value))
                        TextField(
                          controller: targetValueController,
                          decoration: const InputDecoration(
                            labelText: 'Target value',
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                controller.createEntityRuleCondition(
                  group: groupCondition,
                  logicOperator: selectedLogicOperator.value,
                  comparatorOperator: selectedComparatorOperator.value,
                  targetValue: targetValueController.text.trim(),
                  regex: regexController.text.trim(),
                  leftValueObject: ValueObject(
                      name: 'name',
                      type: 'type',
                      nullable: false,
                      entityId: 'entityId'),
                  rightValueObject: ValueObject(
                      name: 'name',
                      type: 'type',
                      nullable: false,
                      entityId: 'entityId'),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _ConditionsWidget extends StatelessWidget {
  final EntityRulesController controller;
  final EntityRuleGroupCondition groupCondition;

  const _ConditionsWidget({
    required this.controller,
    required this.groupCondition,
  });

  @override
  Widget build(BuildContext context) {
    final conditions = groupCondition.conditions;
    final colorScheme = Theme.of(context).colorScheme;
    /*final textTheme = Theme.of(context).textTheme;*/
    return ListView.builder(
      shrinkWrap: true,
      itemCount: conditions.length,
      itemBuilder: (_, index) {
        final condition = conditions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (index > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(condition.logicOperator ?? ''),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${condition.comparatorOperator}: ${condition.targetValue}',
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 16,
                      color: colorScheme.error,
                    ),
                    onPressed: () {
                      /*controller.removeValueObjectRuleCondition(
                        group: groupCondition,
                        condition: condition,
                      );*/
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
*/