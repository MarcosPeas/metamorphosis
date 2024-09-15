import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/value_object_rule/entities/value_object_rule.dart';
import 'package:metamorphis/src/presenter/home/value_objects/value_objects_controller.dart';

class ValueObjectGroupConditionsWidget extends StatelessWidget {
  final ValueObjectsController controller;
  final ValueObjectRule rule;

  const ValueObjectGroupConditionsWidget({
    super.key,
    required this.controller,
    required this.rule,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Conditions'),
        TextButton(
          onPressed: () {
            _showDialogCreateValueObjectGroupCondition(
              context,
            );
          },
          child: const Text('Add condition group'),
        ),
      ],
    );
  }

  void _showDialogCreateValueObjectGroupCondition(BuildContext context) {
    final selectedType = ValueNotifier('AND');
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
