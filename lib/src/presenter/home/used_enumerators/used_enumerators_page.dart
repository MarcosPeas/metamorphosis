import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/entity/entities/entity.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';

import 'used_enumerators_controller.dart';

class UsedEnumeratorsPage extends StatefulWidget {
  const UsedEnumeratorsPage({super.key});

  @override
  State<UsedEnumeratorsPage> createState() => _UsedEnumeratorsPageState();
}

class _UsedEnumeratorsPageState extends State<UsedEnumeratorsPage> {
  late final UsedEnumeratorsController controller;

  @override
  void initState() {
    controller = GetIt.I.get();
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
              '${entityStore.entity.name} Enumerators',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: _showDialogCreateEntityEnumerator,
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
              if (entity.globalEnumerators.isEmpty) {
                return const Center(child: Text('No enumerators'));
              }
              final enumerators = entity.globalEnumerators;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: enumerators.length,
                itemBuilder: (_, index) {
                  final enumerator = enumerators[index];
                  return _EntityGlobalEnumeratorWidget(
                    enumerator: enumerator,
                    onEditTap: () {
                      _showDialogUpdateEntityEnumerator(enumerator, index);
                    },
                    onDeleteTap: () {
                      controller.deleteEnumerator(enumerator);
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

  void _showDialogCreateEntityEnumerator() {
    final globalEnumerators = controller.homeStore.enumerators;
    final enumeratorNotifier = ValueNotifier(
      EntityGlobalEnumerator(name: '', enumerator: null),
    );
    showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: enumeratorNotifier,
          builder: (_, enumerator, ___) {
            return AlertDialog(
              title: const Text('Create an enumerator'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (text) {
                      if (text.isEmpty) {
                        return;
                      }
                      enumeratorNotifier.value = enumerator.copyWith(
                        name: text.trim(),
                      );
                    },
                    onSubmitted: (text) {
                      if (controller.requirementsAreCompleted(enumerator)) {
                        controller.createEnumerator(enumerator);
                        context.pop();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Type'),
                  DropdownButton<GlobalEnumerator>(
                    value: enumerator.enumerator,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        enumeratorNotifier.value = enumerator.copyWith(
                          enumerator: value,
                        );
                      }
                    },
                    items: globalEnumerators.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
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
                  onPressed: controller.requirementsAreCompleted(enumerator)
                      ? () {
                          controller.createEnumerator(enumerator);
                          context.pop();
                        }
                      : null,
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDialogUpdateEntityEnumerator(
    EntityGlobalEnumerator oldEnumerator,
    int index,
  ) {
    final oldName = oldEnumerator.name;
    final globalEnumerators = controller.homeStore.enumerators;
    final enumeratorNotifier = ValueNotifier(oldEnumerator);
    final nameController = TextEditingController(text: oldEnumerator.name);
    oldEnumerator.enumerator = globalEnumerators.firstWhere(
      (element) => element.id == oldEnumerator.enumerator?.id,
    );
    showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: enumeratorNotifier,
          builder: (_, enumerator, ___) {
            return AlertDialog(
              title: const Text('Update enumerator'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (text) {
                      if (text.isEmpty) {
                        return;
                      }
                      enumeratorNotifier.value = enumerator.copyWith(
                        name: text.trim(),
                      );
                    },
                    onSubmitted: (text) {
                      if (controller.requirementsAreCompleted(enumerator, oldName)) {
                        controller.updateEnumerator(
                          oldEnumerator.copyWith(
                            name: nameController.text.trim(),
                            enumerator: enumerator.enumerator,
                          ),
                          index,
                        );
                        context.pop();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Type'),
                  DropdownButton<GlobalEnumerator>(
                    value: enumerator.enumerator,
                    isExpanded: true,
                    onChanged: (value) {
                      if (value != null) {
                        enumeratorNotifier.value = enumerator.copyWith(
                          enumerator: value
                        );
                      }
                    },
                    items: globalEnumerators.map((item) {
                      return DropdownMenuItem(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
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
                  onPressed: controller.requirementsAreCompleted(enumerator, oldName)
                      ? () {
                          controller.updateEnumerator(
                            oldEnumerator.copyWith(
                              name: nameController.text.trim(),
                              enumerator: enumerator.enumerator,
                            ),
                            index,
                          );
                          context.pop();
                        }
                      : null,
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _EntityGlobalEnumeratorWidget extends StatelessWidget {
  final EntityGlobalEnumerator enumerator;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const _EntityGlobalEnumeratorWidget({
    required this.enumerator,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              enumerator.name,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 24),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onEditTap,
              icon: Icon(color: colorScheme.primary, Icons.edit),
              iconSize: 16,
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: onDeleteTap,
              icon: Icon(color: colorScheme.error, Icons.delete),
              iconSize: 16,
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(enumerator.enumerator?.values ?? '-'),
        const SizedBox(height: 16),
      ],
    );
  }
}
