import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

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
                  return ListTile(
                    title: Text(entityRule.errorMessage),
                    trailing: IconButton(
                      onPressed: () {
                        controller.removeEntityRule(entityRule);
                      },
                      icon: Icon(
                        color: colorScheme.primary,
                        Icons.delete,
                        size: 22,
                      ),
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
}
