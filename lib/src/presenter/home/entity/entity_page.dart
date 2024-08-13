import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/_core/constants/types.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';
import 'package:metamorphis/src/presenter/home/entity/entity_controller.dart';

import 'widgets/value_object_group_conditions_widget.dart';

class EntityPage extends StatefulWidget {
  final EntityViewModel entity;

  const EntityPage({super.key, required this.entity});

  @override
  State<EntityPage> createState() => _EntityPageState();
}

class _EntityPageState extends State<EntityPage> {
  late final EntityController controller;

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
              if (entity.valueObjects.isEmpty) {
                return const Center(
                  child: Text('No value objects'),
                );
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
                      _showDialogUpdateValueObject(index, valueObject);
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
    final nameController = TextEditingController();
    final selectedType = ValueNotifier('String');
    final isNullable = ValueNotifier(false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a value object'),
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
                  controller.createValueObject(
                    name: nameController.text.trim(),
                    type: selectedType.value,
                    nullable: isNullable.value,
                  );
                  context.pop();
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Data type'),
              ValueListenableBuilder(
                valueListenable: selectedType,
                builder: (_, type, __) {
                  return DropdownButton(
                    value: type,
                    onChanged: (value) {
                      selectedType.value = value.toString();
                    },
                    items: Types.types.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: isNullable,
                builder: (_, value, __) {
                  return CheckboxListTile(
                    title: const Text('Nullable'),
                    value: value,
                    onChanged: (changedValue) {
                      isNullable.value = changedValue ?? false;
                    },
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
                controller.createValueObject(
                  name: nameController.text.trim(),
                  type: selectedType.value,
                  nullable: isNullable.value,
                );
                context.pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogUpdateValueObject(int viewIndex, ValueObject valueObject) {
    final nameController = TextEditingController();
    final selectedType = ValueNotifier(valueObject.type);
    final isNullable = ValueNotifier(valueObject.nullable);
    nameController.text = valueObject.name;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update a value object'),
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
                  controller.updateValueObject(
                    name: nameController.text.trim(),
                    type: selectedType.value,
                    nullable: isNullable.value,
                    viewIndex: viewIndex,
                  );
                  context.pop();
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Data type'),
              ValueListenableBuilder(
                valueListenable: selectedType,
                builder: (_, type, __) {
                  return DropdownButton(
                    value: type,
                    onChanged: (value) {
                      selectedType.value = value.toString();
                    },
                    items: Types.types.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder(
                valueListenable: isNullable,
                builder: (_, value, __) {
                  return CheckboxListTile(
                    title: const Text('Nullable'),
                    value: value,
                    onChanged: (changedValue) {
                      isNullable.value = changedValue ?? false;
                    },
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
                controller.updateValueObject(
                  name: nameController.text.trim(),
                  type: selectedType.value,
                  nullable: isNullable.value,
                  viewIndex: viewIndex,
                );
                context.pop();
              },
              child: const Text('Update'),
            ),
          ],
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
  final hoverAdd = ValueNotifier(false);

  _EntityRuleWidget({
    required this.valueObject,
    required this.onEditTap,
    required this.onDeleteTap,
    required this.onAddTap,
    required this.onDeleteRule,
    required this.onValueObjectRuleTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final rules = valueObject.rules;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            valueObject.name,
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
                itemCount: rules.length,
                itemBuilder: (_, index) {
                  final rule = rules[index];
                  return ValueListenableBuilder(
                    valueListenable: hoverIndex,
                    builder: (_, __, ___) {
                      return Row(
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
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder(
                valueListenable: hoverAdd,
                builder: (_, __, ___) {
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) {
                      hoverAdd.value = true;
                    },
                    onExit: (_) {
                      hoverAdd.value = false;
                    },
                    child: GestureDetector(
                      onTap: onAddTap,
                      child: Text(
                        'Add rule',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          decoration: hoverAdd.value
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
}
