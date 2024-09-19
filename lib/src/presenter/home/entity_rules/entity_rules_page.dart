import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/entity_rule/entities/entity_rule.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/presenter/home/entity_rules/widgets/entity_rule_card.dart';

import 'entity_rule_dialog.dart';
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
                      EntityRuleCard(
                        controller: controller,
                        index: index,
                        groupCondition: groupCondition,
                        onAddTap: () {
                          _showDialogCreateEntityRuleCondition(
                            context: context,
                            groupCondition: groupCondition,
                            isFirst: groupCondition.conditions.isEmpty,
                            group: groupCondition,
                          );
                        },
                      ),
                    ],
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
    required EntityRuleGroupCondition group,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return EntityRuleDialog(
          controller: controller,
          isFirst: isFirst,
          group: group,
        );
      },
    );
  }
}
