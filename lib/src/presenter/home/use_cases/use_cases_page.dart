import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: useCases.length,
              itemBuilder: (_, index) {
                final useCase = useCases[index];
                return _UseCaseItemList(
                  useCase: useCase,
                  controller: controller,
                );
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
                              controller.createCreateUseCase();
                            },
                            child: Text(
                              'Create Save ${entity.name} Use Case',
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  if (!entity.containsAnyUseCaseByType(UseCaseType.findOne))
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
                  if (!entity.containsAnyUseCaseByType(UseCaseType.paginate))
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.createPaginateUseCase();
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

/*void _showDialogCreateValueObject() {
    final entity = controller.entityStore.entity;
    final valueObjects = entity.valueObjects.map((item) => item.name).toList();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create a pagination use case'),
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
              const Text('Search field'),
              ValueListenableBuilder(
                valueListenable: searchField,
                builder: (_, search, __) {
                  return DropdownButton(
                    value: search,
                    isExpanded: true,
                    onChanged: (value) {
                      searchField.value = value.toString();
                      if (value == 'none') {
                        nameController.text = 'Paginate${entity.name}UseCase';
                        return;
                      }
                      nameController.text =
                          'Paginate${entity.name}By${CasesUtils.toTitleCase(value.toString())}UseCase';
                    },
                    items: ['none', ...valueObjects].map((name) {
                      return DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text('Order by field'),
              ValueListenableBuilder(
                valueListenable: orderByField,
                builder: (_, field, __) {
                  return DropdownButton(
                    value: field,
                    isExpanded: true,
                    onChanged: (value) {
                      orderByField.value = value.toString();
                    },
                    items: valueObjects.map((name) {
                      return DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
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
                controller.createPaginateUseCase();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }*/
}

class _UseCaseItemList extends StatelessWidget {
  final UseCase useCase;
  final UseCasesController controller;

  const _UseCaseItemList({
    required this.useCase,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            useCase.name,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.delete,
              size: 18,
              color: colorScheme.error,
            ),
            onPressed: () {
              controller.deleteUseCase(useCase);
            },
          ),
        ),
        const Divider(),
      ],
    );
  }
}
