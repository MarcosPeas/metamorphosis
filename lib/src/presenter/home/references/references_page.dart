import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';

import 'references_controller.dart';

class ReferencesPage extends StatefulWidget {
  final List<Entity> entities;

  const ReferencesPage({required this.entities, super.key});

  @override
  State<ReferencesPage> createState() => _ReferencesPageState();
}

class _ReferencesPageState extends State<ReferencesPage> {
  late final ReferencesController controller;

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
              'References',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: _showDialogCreateList,
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
                return const Center(child: Text('No compositions'));
              }
              final compositions = entity.references;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: compositions.length,
                itemBuilder: (_, index) {
                  final composition = compositions[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          composition.name,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(_referenceLabel(composition)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () {
                                _showDialogUpdateList(composition);
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
                                controller.removeComposition(composition);
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

  String _referenceLabel(Reference reference) {
    final labels = {
      ReferenceType.oneToOne: 'One to One',
      ReferenceType.oneToMany: 'One to Many',
      ReferenceType.manyToMany: 'Many to Many',
    };
    return '${labels[reference.referenceType]}: ${reference.entity.name}';
  }

  void _showDialogCreateList() {
    final nameController = TextEditingController();
    final selectedEntity = ValueNotifier<Entity?>(null);
    final referenceType = ValueNotifier(ReferenceType.oneToOne);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a reference of entities'),
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
                  controller.createComposition(
                    name: nameController.text.trim(),
                    entity: selectedEntity.value,
                    compositionType: referenceType.value,
                  );
                  context.pop();
                },
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              const Text('Entity'),
              ValueListenableBuilder(
                valueListenable: selectedEntity,
                builder: (_, entity, __) {
                  final entities = [...widget.entities];
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
              ValueListenableBuilder(
                valueListenable: referenceType,
                builder: (_, currentType, __) {
                  return DropdownButton(
                    value: currentType,
                    isExpanded: true,
                    onChanged: (value) {
                      referenceType.value = value!;
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ReferenceType.oneToOne,
                        child: Text('One to One'),
                      ),
                      DropdownMenuItem(
                        value: ReferenceType.oneToMany,
                        child: Text('One to Many'),
                      ),
                      DropdownMenuItem(
                        value: ReferenceType.manyToMany,
                        child: Text('Many to Many'),
                      ),
                    ],
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
                controller.createComposition(
                  name: nameController.text.trim(),
                  entity: selectedEntity.value,
                  compositionType: referenceType.value,
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

  void _showDialogUpdateList(Reference reference) {
    final nameController = TextEditingController(text: reference.name);
    final selectedEntity = ValueNotifier<Entity>(reference.entity);
    final compositionType = ValueNotifier(reference.referenceType);
    final entities = [...widget.entities];
    final index = entities.indexWhere((item) {
      return item.id == reference.entity.id;
    });
    entities[index] = reference.entity;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update the reference of entities'),
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
                  controller.updateComposition(
                    entity: selectedEntity.value,
                    name: nameController.text.trim(),
                    list: reference,
                    compositionType: compositionType.value,
                  );
                  context.pop();
                },
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              const Text('Entity'),
              ValueListenableBuilder(
                valueListenable: selectedEntity,
                builder: (_, entity, __) {
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
              ValueListenableBuilder(
                valueListenable: compositionType,
                builder: (_, currentType, __) {
                  return DropdownButton(
                    value: currentType,
                    isExpanded: true,
                    onChanged: (value) {
                      compositionType.value = value!;
                    },
                    items: const [
                      DropdownMenuItem(
                        value: ReferenceType.oneToOne,
                        child: Text('One to One'),
                      ),
                      DropdownMenuItem(
                        value: ReferenceType.oneToMany,
                        child: Text('One to Many'),
                      ),
                      DropdownMenuItem(
                        value: ReferenceType.manyToMany,
                        child: Text('Many to Many'),
                      ),
                    ],
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
                controller.updateComposition(
                  entity: selectedEntity.value,
                  name: nameController.text.trim(),
                  list: reference,
                  compositionType: compositionType.value,
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
