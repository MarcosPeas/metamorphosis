import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/_core/constants/types.dart';
import 'package:metamorphis/src/domain/value_object/entities/value_object.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';
import 'package:metamorphis/src/presenter/home/entity/entity_controller.dart';

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
              if (entityStore.valueObjects.isEmpty) {
                return const Center(
                  child: Text('No value objects'),
                );
              }
              final valueObjects = entityStore.valueObjects;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: valueObjects.length,
                itemBuilder: (_, index) {
                  final valueObject = valueObjects[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () {
                            _showDialogUpdateValueObject(index, valueObject);
                          },
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 20,
                            color: colorScheme.error,
                          ),
                          onPressed: () {
                            _showDialogDeleteValueObject(index, valueObject);
                          },
                        ),
                      ],
                    ),
                    title: Text(
                      valueObject.name,
                      style: textTheme.bodyMedium,
                    ),
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
                    entity: widget.entity,
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
                  entity: widget.entity,
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
                    entity: widget.entity,
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
                  entity: widget.entity,
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
}
