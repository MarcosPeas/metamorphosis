import 'package:flutter/material.dart';
import 'package:metamorphis/src/domain/entity_rule_condition/entity_rule_condition.dart';
import 'package:metamorphis/src/domain/entity_rule_group_condition/entities/entity_rule_group_condition.dart';
import 'package:metamorphis/src/presenter/home/entity_rules/entity_rules_controller.dart';

class EntityRuleCard extends StatelessWidget {
  final hoverIndex = ValueNotifier(-1);
  final hoverAddRuleGroup = ValueNotifier(false);
  final EntityRulesController controller;
  final int index;
  final EntityRuleGroupCondition groupCondition;
  final VoidCallback onAddTap;

  EntityRuleCard({
    super.key,
    required this.controller,
    required this.index,
    required this.groupCondition,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card(
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
                Text(
                  'Group ${index + 1}',
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                    decoration: hoverIndex.value == index
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    size: 18,
                  ),
                  onPressed: onAddTap,
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: groupCondition.conditions.length,
              itemBuilder: (_, index) {
                final condition = groupCondition.conditions[index];
                if (condition.composition != null) {
                  return _buildConditionComposition(
                    condition: condition,
                    isFirst: index == 0,
                  );
                }
                return _buildConditionValueObject(
                  condition: condition,
                  isFirst: index == 0,
                );
              },
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                      onTap: onAddTap,
                      child: Text(
                        'Add condition',
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
        ),
      ),
    );
  }

  Widget _buildConditionValueObject({
    required EntityRuleCondition condition,
    required bool isFirst,
  }) {
    final leftValueObject = condition.leftValueObject!;
    final rightValueObject = condition.rightValueObject;
    final targetValue = condition.targetValue;
    String rightValue = '';
    if (rightValueObject != null) {
      rightValue += ' ';
      rightValue += condition.comparatorOperator;
      rightValue += ' ${rightValueObject.name}';
    } else if (targetValue.isNotEmpty) {
      rightValue += ' ';
      rightValue += condition.comparatorOperator;
      rightValue += ' $targetValue';
    } else {
      rightValue += ': ${condition.comparatorOperator}';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isFirst) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(condition.logicOperator),
          ),
          Text('${leftValueObject.name}$rightValue'),
        ],
      ),
    );
  }

  Widget _buildConditionComposition({
    required EntityRuleCondition condition,
    required bool isFirst,
  }) {
    final composition = condition.composition!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isFirst) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(condition.logicOperator),
          ),
          Text('${composition.name}: ${condition.comparatorOperator}'),
        ],
      ),
    );
  }
}
