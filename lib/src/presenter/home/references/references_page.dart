import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/reference/entities/reference.dart';
import 'package:metamorphis/src/presenter/_core/extensions/words_extensions.dart';

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
              onPressed: _showDialogReference,
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
                return const Center(child: Text('No references'));
              }
              final references = entity.references;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: references.length,
                itemBuilder: (_, index) {
                  final reference = references[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          reference.name,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _referenceLabel(
                            origin: entity,
                            reference: reference,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 18),
                              onPressed: () {
                                _showDialogUpdateReference(reference);
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
                                controller.removeComposition(reference);
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

  String _referenceLabel({
    required Entity origin,
    required Reference reference,
  }) {
    if (reference.referenceType == ReferenceType.oneToOne) {
      return 'One ${origin.name} to one ${reference.entity.name}';
    } else if (reference.referenceType == ReferenceType.manyToOne) {
      return 'Many ${origin.name.plural()} to one ${reference.entity.name}';
    } else {
      return 'Many ${origin.name.plural()} to many ${reference.entity.name.plural()}';
    }
  }

  void _showDialogReference() {
    final nameController = TextEditingController();
    final selectedEntity = ValueNotifier<Entity?>(null);
    final autoLoadNotifier = ValueNotifier<bool>(false);
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
                  controller.createReference(
                    name: nameController.text.trim(),
                    entity: selectedEntity.value,
                    autoLoad: autoLoadNotifier.value,
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
                        value: ReferenceType.manyToOne,
                        child: Text('Many to One'),
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
              ValueListenableBuilder(
                valueListenable: autoLoadNotifier,
                builder: (_, autoLoad, ___) {
                  return SwitchListTile(
                    onChanged: (value) => autoLoadNotifier.value = value,
                    value: autoLoad,
                    title: Text('Autoload'),
                  );
                }
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
                controller.createReference(
                  name: nameController.text.trim(),
                  entity: selectedEntity.value,
                  autoLoad: autoLoadNotifier.value,
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

  void _showDialogUpdateReference(Reference reference) {
    final nameController = TextEditingController(text: reference.name);
    final selectedEntity = ValueNotifier<Entity>(reference.entity);
    final compositionType = ValueNotifier(reference.referenceType);
    final autoLoadNotifier = ValueNotifier<bool>(reference.autoLoad);
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
                    reference: reference,
                    compositionType: compositionType.value,
                    autoLoad: autoLoadNotifier.value,
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
                        value: ReferenceType.manyToOne,
                        child: Text('Many to One'),
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
              ValueListenableBuilder(
                  valueListenable: autoLoadNotifier,
                  builder: (_, autoLoad, ___) {
                    return SwitchListTile(
                      onChanged: (value) => autoLoadNotifier.value = value,
                      value: autoLoad,
                      title: Text('Autoload'),
                    );
                  }
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
                  reference: reference,
                  compositionType: compositionType.value,
                  autoLoad: autoLoadNotifier.value,
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
}
