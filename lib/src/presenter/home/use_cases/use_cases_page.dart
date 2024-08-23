import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/_core/utils/types_utils.dart';
import 'package:metamorphis/src/domain/use_case/entities/use_case.dart';
import 'package:metamorphis/src/presenter/home/use_cases/use_cases_controller.dart';

class UseCasesPage extends StatefulWidget {
  const UseCasesPage({super.key});

  @override
  State<UseCasesPage> createState() => _UseCasesPageState();
}

class _UseCasesPageState extends State<UseCasesPage> {
  late final UseCasesController controller;

  @override
  void initState() {
    controller = GetIt.instance.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final store = controller.entityStore;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ListenableBuilder(
      listenable: store,
      builder: (context, widget) {
        final entity = store.entity;
        final useCases = entity.useCases;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Use Cases',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: () {
                    _showDialogCreateValueObject();
                  },
                  icon: Icon(
                    color: colorScheme.primary,
                    Icons.add,
                    size: 22,
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: useCases.length,
              itemBuilder: (_, index) {
                final useCase = useCases[index];
                return Text(useCase.name);
              },
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  if (!entity.containsAnyUseCaseByType(UseCaseType.create))
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.createSaveUseCase();
                            },
                            child: Text(
                              'Create Save ${entity.name} Use Case',
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  if (!entity.containsAnyUseCaseByType(UseCaseType.read))
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.createFindByIdUseCase();
                            },
                            child: Text(
                              'Create Find ${entity.name} By Id Use Case',
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  if (!entity.containsAnyUseCaseByType(UseCaseType.update))
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.createUpdateUseCase();
                            },
                            child: Text(
                              'Create Update ${entity.name} Use Case',
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  if (!entity.containsAnyUseCaseByType(UseCaseType.delete))
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.createDeleteUseCase();
                            },
                            child: Text(
                              'Create Delete ${entity.name} Use Case',
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            log('Modal de criar paginação');
                          },
                          child: Text(
                            'Create Paginate ${entity.name} Use Case',
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
                    isExpanded: true,
                    onChanged: (value) {
                      selectedType.value = value.toString();
                    },
                    items: TypesUtils.types.map((type) {
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
