import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/collections/entities/entity_list.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';

import 'entity_lists_controller.dart';

class EntityListsPage extends StatefulWidget {
  final List<Entity> entities;

  const EntityListsPage({required this.entities, super.key});

  @override
  State<EntityListsPage> createState() => _EntityListsPageState();
}

class _EntityListsPageState extends State<EntityListsPage> {
  late final EntityListsController controller;

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
              'Lists',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: _showDialogCreateList,
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
                  child: Text('No lists'),
                );
              }
              final lists = entity.lists;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: lists.length,
                itemBuilder: (_, index) {
                  final list = lists[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          list.name,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('List<${list.entity.name}>'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () {
                                _showDialogUpdateList(list);
                              },
                            ),
                            const SizedBox(width: 1),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                size: 18,
                                color: colorScheme.error,
                              ),
                              onPressed: () {
                                controller.removeEntityList(list);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDialogCreateList() {
    final nameController = TextEditingController();
    final selectedEntity = ValueNotifier<Entity?>(null);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a list of entities'),
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
                  controller.createList(
                    name: nameController.text.trim(),
                    entity: selectedEntity.value,
                  );
                  context.pop();
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Entity'),
              ValueListenableBuilder(
                valueListenable: selectedEntity,
                builder: (_, entity, __) {
                  final entities = [...widget.entities];
                  entities.removeWhere((item) {
                    return item.id == controller.entityStore.entity.id;
                  });
                  return DropdownButton(
                    value: selectedEntity.value,
                    isExpanded: true,
                    onChanged: (value) {
                      selectedEntity.value = value;
                    },
                    items: entities.map((element) {
                      return DropdownMenuItem(
                        value: element,
                        child: Text(element.name),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
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
                controller.createList(
                  name: nameController.text.trim(),
                  entity: selectedEntity.value,
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

  void _showDialogUpdateList(EntityList list) {
    final nameController = TextEditingController(text: list.name);
    final selectedEntity = ValueNotifier<Entity>(list.entity);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update the list of entities'),
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
                  controller.updateEntityList(
                    entity: selectedEntity.value,
                    name: nameController.text.trim(),
                    list: list,
                  );
                  context.pop();
                },
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 16),
              const Text('Entity'),
              ValueListenableBuilder(
                valueListenable: selectedEntity,
                builder: (_, entity, __) {
                  final entities = [...widget.entities];
                  entities.removeWhere((item) {
                    return item.id == controller.entityStore.entity.id;
                  });
                  return DropdownButton(
                    value: selectedEntity.value,
                    isExpanded: true,
                    onChanged: (value) {
                      selectedEntity.value = value!;
                    },
                    items: entities.map((element) {
                      return DropdownMenuItem(
                        value: element,
                        child: Text(element.name),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
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
                controller.updateEntityList(
                  entity: selectedEntity.value,
                  name: nameController.text.trim(),
                  list: list,
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
}
