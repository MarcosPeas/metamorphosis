import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/_core/utils/types_utils.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_group_condition/entities/value_object_group_condition.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';

import 'value_objects_controller.dart';
import 'widgets/value_object_group_conditions_widget.dart';

class ValueObjectsPage extends StatefulWidget {
  final EntityViewModel entity;

  const ValueObjectsPage({super.key, required this.entity});

  @override
  State<ValueObjectsPage> createState() => _ValueObjectsPageState();
}

class _ValueObjectsPageState extends State<ValueObjectsPage> {
  late final ValueObjectsController controller;

  @override
  void initState() {
    controller = GetIt.instance.get();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(widget.entity);
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
              'Value Objects',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: _showDialogCreateValueObject,
              icon: Icon(color: colorScheme.primary, Icons.add, size: 22),
            ),
          ],
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: entityStore,
            builder: (context, _) {
              if (entityStore.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              final entity = entityStore.entity;
              if (entity.valueObjects.isEmpty) {
                return const Center(child: Text('No value objects'));
              }
              final valueObjects = entity.valueObjects;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: valueObjects.length,
                itemBuilder: (_, index) {
                  final valueObject = valueObjects[index];
                  return _EntityRuleWidget(
                    valueObject: valueObject,
                    onAddTap: () {
                      _showDialogCreateValueObjectRule(index, valueObject);
                    },
                    onEditTap: () {
                      _showDialogUpdateValueObject(valueObject);
                    },
                    onDeleteTap: () {
                      _showDialogDeleteValueObject(index, valueObject);
                    },
                    onDeleteRule: (rule) {
                      controller.removeValueObjectRule(
                        viewIndex: index,
                        rule: rule,
                      );
                    },
                    onValueObjectRuleTap: (rule) {
                      _showDialogCreateValueObjectGroupCondition(rule);
                    },
                    controller: controller,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDialogCreateValueObject() {
    final valueObject = ValueNotifier(
      ValueObject.ofEntity(controller.entityStore.entity),
    );
    showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: valueObject,
          builder: (_, vo, ___) {
            return AlertDialog(
              title: const Text('Create a value object'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    onChanged: (text) {
                      if (text.isEmpty) {
                        return;
                      }
                      valueObject.value = vo.copyWith(name: text.trim());
                    },
                    onSubmitted: (text) {
                      if (vo.requirementsAreCompleted) {
                        controller.createValueObject(valueObject.value);
                        context.pop();
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Data type'),
                  DropdownButton(
                    value: valueObject.value.type,
                    isExpanded: true,
                    onChanged: (value) {
                      valueObject.value = vo.copyWith(type: value.toString());
                    },
                    items: TypesUtils.types.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                  ),
                  if (vo.type == 'Enum') ...[
                    const SizedBox(height: 4),
                    TextField(
                      decoration: const InputDecoration(labelText: 'Enum name'),
                      onChanged: (text) {
                        if (text.isEmpty) {
                          return;
                        }
                        valueObject.value = vo.copyWith(enumName: text.trim());
                      },
                      onSubmitted: (text) {
                        if (vo.requirementsAreCompleted) {
                          controller.createValueObject(valueObject.value);
                          context.pop();
                        }
                      },
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Enum values',
                        hint: Text('Ex.: RED, GREEN, DARK_BLUE'),
                      ),
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final validCharacters = RegExp(r'^[a-zA-Z0-9_, ]*$');
                          if (validCharacters.hasMatch(newValue.text)) {
                            return newValue.copyWith(
                              text: newValue.text.toUpperCase(),
                            );
                          }
                          return oldValue;
                        }),
                      ],
                      onChanged: (text) {
                        valueObject.value = vo.copyWith(
                          enumValues: text.trim(),
                        );
                      },
                      onSubmitted: (text) {
                        if (vo.requirementsAreCompleted) {
                          controller.createValueObject(valueObject.value);
                          context.pop();
                        }
                      },
                    ),
                  ],
                  if (vo.type != 'Enum') ...[
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Nullable'),
                      value: valueObject.value.isNullable,
                      onChanged: (value) {
                        valueObject.value = vo.copyWith(isNullable: value);
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Unique'),
                      value: valueObject.value.isUnique,
                      onChanged: (value) {
                        valueObject.value = vo.copyWith(isUnique: value);
                      },
                    ),
                  ],
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
                  onPressed: vo.requirementsAreCompleted
                      ? () {
                          controller.createValueObject(valueObject.value);
                          context.pop();
                        }
                      : null,
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDialogUpdateValueObject(ValueObject oldVO) {
    final valueObject = ValueNotifier(oldVO);
    final nameController = TextEditingController(text: oldVO.name);
    final enumNameController = TextEditingController(text: oldVO.enumName);
    final enumValueController = TextEditingController(text: oldVO.enumValues);
    showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: valueObject,
          builder: (_, vo, ___) {
            return AlertDialog(
              title: const Text('Update a value object'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
                    onChanged: (text) {
                      if (text.isEmpty) {
                        return;
                      }
                      valueObject.value = vo.copyWith(name: text.trim());
                    },
                    onSubmitted: (text) {
                      if (vo.requirementsAreCompleted) {
                        controller.updateValueObject(valueObject.value);
                        context.pop();
                      }
                    },
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Data type'),
                  DropdownButton(
                    value: valueObject.value.type,
                    isExpanded: true,
                    onChanged: (value) {
                      valueObject.value = vo.copyWith(type: value.toString());
                    },
                    items: TypesUtils.types.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                  ),
                  if (vo.type == 'Enum') ...[
                    const SizedBox(height: 4),
                    TextField(
                      controller: enumNameController,
                      decoration: const InputDecoration(labelText: 'Enum name'),
                      onChanged: (text) {
                        if (text.isEmpty) {
                          return;
                        }
                        valueObject.value = vo.copyWith(enumName: text.trim());
                      },
                      onSubmitted: (text) {
                        if (vo.requirementsAreCompleted) {
                          controller.updateValueObject(valueObject.value);
                          context.pop();
                        }
                      },
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: enumValueController,
                      decoration: const InputDecoration(
                        labelText: 'Enum values',
                        hint: Text('Ex.: RED, GREEN, DARK_BLUE'),
                      ),
                      inputFormatters: [
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final validCharacters = RegExp(r'^[a-zA-Z0-9_, ]*$');
                          if (validCharacters.hasMatch(newValue.text)) {
                            return newValue.copyWith(
                              text: newValue.text.toUpperCase(),
                            );
                          }
                          return oldValue;
                        }),
                      ],
                      onChanged: (text) {
                        valueObject.value = vo.copyWith(
                          enumValues: text.trim(),
                        );
                      },
                      onSubmitted: (text) {
                        if (vo.requirementsAreCompleted) {
                          controller.updateValueObject(valueObject.value);
                          context.pop();
                        }
                      },
                    ),
                  ],
                  if (vo.type != 'Enum') ...[
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Nullable'),
                      value: valueObject.value.isNullable,
                      onChanged: (value) {
                        valueObject.value = vo.copyWith(isNullable: value);
                      },
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Unique'),
                      value: valueObject.value.isUnique,
                      onChanged: (value) {
                        valueObject.value = vo.copyWith(isUnique: value);
                      },
                    ),
                  ],
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
                  onPressed: vo.requirementsAreCompleted
                      ? () {
                          controller.updateValueObject(valueObject.value);
                          context.pop();
                        }
                      : null,
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDialogDeleteValueObject(int viewIndex, ValueObject valueObject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete a value object'),
          content: Text('Are you sure you want to delete ${valueObject.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteValueObject(
                  valueObject: valueObject,
                  viewIndex: viewIndex,
                );
                context.pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogCreateValueObjectGroupCondition(ValueObjectRule rule) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Group conditions'),
          content: ValueObjectGroupConditionsWidget(
            controller: controller,
            rule: rule,
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

  void _showDialogCreateValueObjectRule(
    int viewIndex,
    ValueObject valueObject,
  ) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rule for ${valueObject.name}'),
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
                  controller.addValueObjectRule(
                    errorMessage: nameController.text.trim(),
                    viewIndex: viewIndex,
                  );
                },
                decoration: const InputDecoration(labelText: 'Error message'),
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
                controller.addValueObjectRule(
                  errorMessage: nameController.text.trim(),
                  viewIndex: viewIndex,
                );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class _EntityRuleWidget extends StatelessWidget {
  final ValueObject valueObject;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;
  final VoidCallback onAddTap;
  final void Function(ValueObjectRule rule) onDeleteRule;
  final void Function(ValueObjectRule rule) onValueObjectRuleTap;
  final hoverIndex = ValueNotifier(-1);
  final hoverAddRule = ValueNotifier(false);
  final ValueObjectsController controller;

  _EntityRuleWidget({
    required this.valueObject,
    required this.onEditTap,
    required this.onDeleteTap,
    required this.onAddTap,
    required this.onDeleteRule,
    required this.onValueObjectRuleTap,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final rules = valueObject.rules;
    String title = '${valueObject.name} (${valueObject.type})';
    if (!valueObject.isEnum) {
      title +=
          '${valueObject.isUnique ? ', unique' : ''}${valueObject.isNullable ? ', nullable' : ''}';
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            title,
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
                icon: Icon(Icons.delete, size: 18, color: colorScheme.error),
                onPressed: onDeleteTap,
              ),
            ],
          ),
        ),
        if (valueObject.isEnum)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(valueObject.enumValues),
          ),
        if (!valueObject.isEnum)
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: rules.length,
                  itemBuilder: (_, index) {
                    final rule = rules[index];
                    return ValueListenableBuilder(
                      valueListenable: hoverIndex,
                      builder: (_, __, ___) {
                        final hoverAddRuleGroup = ValueNotifier(false);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
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
                                    onTap: () {
                                      onValueObjectRuleTap(rule);
                                    },
                                    child: Text(
                                      rule.errorMessage,
                                      style: textTheme.bodyLarge?.copyWith(
                                        color: colorScheme.primary,
                                        decoration: hoverIndex.value == index
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 18),
                                  onPressed: () {
                                    onDeleteRule(rule);
                                  },
                                ),
                              ],
                            ),
                            _GroupConditionWidget(
                              rule: rule,
                              valueObject: valueObject,
                              controller: controller,
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
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
                                        _showDialogCreateValueObjectGroupCondition(
                                          context: context,
                                          rule: rule,
                                        );
                                      },
                                      child: Text(
                                        'Add conditions group',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.primary,
                                          decoration: hoverAddRuleGroup.value
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
                        onTap: onAddTap,
                        child: Text(
                          'Add rule',
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
    required ValueObjectRule rule,
    required BuildContext context,
  }) {
    final selectedType = ValueNotifier('AND');
    if (rule.groupConditions.isEmpty) {
      controller.createValueObjectGroupCondition(
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
                      DropdownMenuItem(value: 'AND', child: Text('AND')),
                      DropdownMenuItem(value: 'OR', child: Text('OR')),
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
                controller.createValueObjectGroupCondition(
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
}

class _GroupConditionWidget extends StatelessWidget {
  final ValueObject valueObject;
  final ValueObjectRule rule;
  final ValueObjectsController controller;

  const _GroupConditionWidget({
    required this.valueObject,
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
                  child: Text(groupCondition.logicOperator),
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
                                  controller.removeValueObjectGroupCondition(
                                    rule: rule,
                                    groupCondition: groupCondition,
                                  );
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
                                    valueObject: valueObject,
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
    required ValueObject valueObject,
    required ValueObjectGroupCondition groupCondition,
    required BuildContext context,
    required bool isFirst,
  }) {
    if (valueObject.isString) {
      _showDialogCreateValueObjectConditionWithString(
        groupIndex: groupIndex,
        valueObject: valueObject,
        groupCondition: groupCondition,
        context: context,
        isFirst: isFirst,
      );
    } else if (valueObject.isNumber) {
      _showDialogCreateValueObjectConditionWithNumber(
        groupIndex: groupIndex,
        valueObject: valueObject,
        groupCondition: groupCondition,
        context: context,
        isFirst: isFirst,
      );
    } else if (valueObject.isDateTime) {
      _showDialogCreateValueObjectConditionWithDateTime(
        groupIndex: groupIndex,
        valueObject: valueObject,
        groupCondition: groupCondition,
        context: context,
        isFirst: isFirst,
      );
    } else {
      _showDialogCreateValueObjectConditionDefault(
        groupIndex: groupIndex,
        valueObject: valueObject,
        groupCondition: groupCondition,
        context: context,
        isFirst: isFirst,
      );
    }
  }

  void _showDialogCreateValueObjectConditionWithString({
    required int groupIndex,
    required ValueObject valueObject,
    required ValueObjectGroupCondition groupCondition,
    required BuildContext context,
    required bool isFirst,
  }) {
    final selectedLogicOperator = ValueNotifier('AND');
    final comparatorOperators = TypesUtils.conditions(valueObject.type);
    final selectedComparatorOperator = ValueNotifier(comparatorOperators.first);
    final targetValueController = TextEditingController();
    final shortOperators = ['is empty', 'is not empty'];
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
                            DropdownMenuItem(value: 'AND', child: Text('AND')),
                            DropdownMenuItem(value: 'OR', child: Text('OR')),
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
                              selectedComparatorOperator.value = value
                                  .toString();
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
                      if (!shortOperators.contains(
                        selectedComparatorOperator.value,
                      ))
                        const SizedBox(height: 8),
                      if (!shortOperators.contains(
                        selectedComparatorOperator.value,
                      ))
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
                controller.createValueObjectRuleCondition(
                  group: groupCondition,
                  logicOperator: selectedLogicOperator.value,
                  comparatorOperator: selectedComparatorOperator.value,
                  targetValue: targetValueController.text.trim(),
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
    required ValueObjectGroupCondition groupCondition,
    required BuildContext context,
    required bool isFirst,
  }) {
    final selectedLogicOperator = ValueNotifier('AND');
    final comparatorOperators = TypesUtils.conditions(valueObject.type);
    final selectedComparatorOperator = ValueNotifier(comparatorOperators.first);
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
                            DropdownMenuItem(value: 'AND', child: Text('AND')),
                            DropdownMenuItem(value: 'OR', child: Text('OR')),
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
                              selectedComparatorOperator.value = value
                                  .toString();
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
                controller.createValueObjectRuleCondition(
                  group: groupCondition,
                  logicOperator: selectedLogicOperator.value,
                  comparatorOperator: selectedComparatorOperator.value,
                  targetValue: targetValueController.text.trim(),
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogCreateValueObjectConditionWithDateTime({
    required int groupIndex,
    required ValueObject valueObject,
    required ValueObjectGroupCondition groupCondition,
    required BuildContext context,
    required bool isFirst,
  }) {
    final selectedLogicOperator = ValueNotifier('AND');
    final comparatorOperators = TypesUtils.conditions(valueObject.type);
    final selectedComparatorOperator = ValueNotifier(comparatorOperators.first);
    final dateNotifier = ValueNotifier<String?>(null);
    final targetValueController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create a value object condition:\ngroup ${groupIndex + 1}',
          ),
          content: ValueListenableBuilder(
            valueListenable: dateNotifier,
            builder: (_, __, ___) {
              return ValueListenableBuilder(
                valueListenable: selectedLogicOperator,
                builder: (_, operator, __) {
                  return ValueListenableBuilder(
                    valueListenable: selectedComparatorOperator,
                    builder: (_, b, __) {
                      final textTheme = Theme.of(context).textTheme;
                      final colorScheme = Theme.of(context).colorScheme;
                      final comparator = selectedComparatorOperator.value;
                      final isInputInt =
                          TypesUtils.isInputIntegerComparatorForDate(
                            comparator,
                          );
                      final isInputDate =
                          TypesUtils.isSelectableComparatorForDate(comparator);
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
                                  selectedComparatorOperator.value = value
                                      .toString();
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
                          if (isInputDate)
                            GestureDetector(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );
                                if (date == null) {
                                  return;
                                }
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                    DateTime.now(),
                                  ),
                                );
                                if (time == null) {
                                  return;
                                }
                                final dateTime = DateTime(
                                  date.year,
                                  date.month,
                                  date.day,
                                  time.hour,
                                  time.minute,
                                );
                                dateNotifier.value = dateTime.toIso8601String();
                              },
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                    color: colorScheme.primary,
                                    width: 1.0,
                                  ),
                                ),
                                child: Text(
                                  dateNotifier.value ?? 'Select the date',
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          if (isInputInt)
                            TextField(
                              onChanged: (value) {
                                dateNotifier.value = null;
                              },
                              controller: targetValueController,
                              decoration: const InputDecoration(
                                labelText: 'Add a number',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
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
                controller.createValueObjectRuleCondition(
                  group: groupCondition,
                  logicOperator: selectedLogicOperator.value,
                  comparatorOperator: selectedComparatorOperator.value,
                  targetValue:
                      dateNotifier.value ?? targetValueController.text.trim(),
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
    required ValueObject valueObject,
    required ValueObjectGroupCondition groupCondition,
    required BuildContext context,
    required bool isFirst,
  }) {
    final selectedLogicOperator = ValueNotifier('AND');
    final comparatorOperators = TypesUtils.conditions(valueObject.type);
    final selectedComparatorOperator = ValueNotifier(comparatorOperators.first);
    final targetValueController = TextEditingController();
    final shortOperators = ['is empty', 'is not empty'];
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
                            DropdownMenuItem(value: 'AND', child: Text('AND')),
                            DropdownMenuItem(value: 'OR', child: Text('OR')),
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
                              selectedComparatorOperator.value = value
                                  .toString();
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
                      if (!shortOperators.contains(
                        selectedComparatorOperator.value,
                      ))
                        const SizedBox(height: 8),
                      if (!shortOperators.contains(
                        selectedComparatorOperator.value,
                      ))
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
                controller.createValueObjectRuleCondition(
                  group: groupCondition,
                  logicOperator: selectedLogicOperator.value,
                  comparatorOperator: selectedComparatorOperator.value,
                  targetValue: targetValueController.text.trim(),
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
  final ValueObjectsController controller;
  final ValueObjectGroupCondition groupCondition;

  const _ConditionsWidget({
    required this.controller,
    required this.groupCondition,
  });

  @override
  Widget build(BuildContext context) {
    final conditions = groupCondition.conditions;
    final colorScheme = Theme.of(context).colorScheme;
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
                      controller.removeValueObjectRuleCondition(
                        group: groupCondition,
                        condition: condition,
                      );
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
