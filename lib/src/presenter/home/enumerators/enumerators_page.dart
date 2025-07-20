import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/enumerator/entities/enumerator.dart';

import 'enumerators_controller.dart';

class EnumeratorsPage extends StatefulWidget {
  const EnumeratorsPage({super.key});

  @override
  State<EnumeratorsPage> createState() => _EnumeratorsPageState();
}

class _EnumeratorsPageState extends State<EnumeratorsPage> {
  late final EnumeratorsController controller;

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Enumerators',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: _showDialogCreateEnumerator,
              icon: Icon(color: colorScheme.primary, Icons.add, size: 22),
            ),
          ],
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: store,
            builder: (context, widget) {
              final entity = store.entity;
              final enumerators = entity.enumerators;
              if (enumerators.isEmpty) {
                return const Center(child: Text('No enumerators'));
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: enumerators.length,
                itemBuilder: (_, index) {
                  final enumerator = enumerators[index];
                  return _EnumeratorItemList(
                    enumerator: enumerator,
                    controller: controller,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showDialogCreateEnumerator() {
    final name = ValueNotifier<String>('');
    final values = ValueNotifier<String>('');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create an enumerator'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                onChanged: (text) {
                  name.value = text.trim();
                },
                onSubmitted: (text) {
                  final isInvalid = name.value.isEmpty || values.value.isEmpty;
                  if (isInvalid) {
                    return;
                  }
                  controller.createEnumerator(
                    name: name.value,
                    values: values.value,
                  );
                  context.pop();
                  controller.createEnumerator(
                    name: name.value,
                    values: values.value,
                  );
                  context.pop();
                },
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final validCharacters = RegExp(r'^[a-zA-Z0-9_, ]*$');
                    if (validCharacters.hasMatch(newValue.text)) {
                      return newValue.copyWith(
                        text: newValue.text.toUpperCase(),
                      );
                    }
                    return oldValue;
                  }),
                ],
                onChanged: (text) {
                  values.value = text.trim();
                },
                onSubmitted: (text) {
                  final isInvalid = name.value.isEmpty || values.value.isEmpty;
                  if (isInvalid) {
                    return;
                  }
                  controller.createEnumerator(
                    name: name.value,
                    values: values.value,
                  );
                  context.pop();
                },
                decoration: const InputDecoration(
                  labelText: 'Types',
                  hint: Text('Ex.: USER, ADMIN, GUEST'),
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
            ValueListenableBuilder(
              key: UniqueKey(),
              valueListenable: name,
              builder: (_, __, ___) {
                return ValueListenableBuilder(
                  key: UniqueKey(),
                  valueListenable: values,
                  builder: (_, __, ___) {
                    final tName = name.value.trim();
                    final tValues = values.value.trim();
                    final isInvalid = tName.isEmpty || tValues.isEmpty;
                    return TextButton(
                      onPressed: isInvalid
                          ? null
                          : () {
                              controller.createEnumerator(
                                name: name.value,
                                values: values.value,
                              );
                              context.pop();
                            },
                      child: const Text('Create'),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _EnumeratorItemList extends StatelessWidget {
  final Enumerator enumerator;
  final EnumeratorsController controller;

  const _EnumeratorItemList({
    required this.enumerator,
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
            enumerator.name,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            enumerator.values,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, size: 18, color: colorScheme.primary),
                onPressed: () {
                  _showDialogUpdateEnumerator(enumerator, context);
                },
              ),
              const SizedBox(width: 2),
              IconButton(
                icon: Icon(Icons.delete, size: 18, color: colorScheme.error),
                onPressed: () {
                  controller.deleteEnumerator(enumerator);
                },
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  void _showDialogUpdateEnumerator(
    Enumerator enumerator,
    BuildContext context,
  ) {
    final nameController = TextEditingController(text: enumerator.name);
    final valuesController = TextEditingController(text: enumerator.values);
    final name = ValueNotifier<String>(enumerator.name);
    final values = ValueNotifier<String>(enumerator.values);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update enumerator: ${enumerator.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: nameController,
                onChanged: (text) {
                  name.value = text.trim();
                },
                onSubmitted: (text) {
                  final isInvalid = name.value.isEmpty || values.value.isEmpty;
                  if (isInvalid) {
                    return;
                  }

                  final newEnum = Enumerator(
                    id: enumerator.id,
                    name: name.value,
                    values: values.value,
                  );
                  controller.updateEnumerator(newEnum);
                  context.pop();
                  controller.createEnumerator(
                    name: name.value,
                    values: values.value,
                  );
                  context.pop();
                },
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: valuesController,
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    final validCharacters = RegExp(r'^[a-zA-Z0-9_, ]*$');
                    if (validCharacters.hasMatch(newValue.text)) {
                      return newValue.copyWith(
                        text: newValue.text.toUpperCase(),
                      );
                    }
                    return oldValue;
                  }),
                ],
                onChanged: (text) {
                  values.value = text.trim();
                },
                onSubmitted: (text) {
                  final isInvalid = name.value.isEmpty || values.value.isEmpty;
                  if (isInvalid) {
                    return;
                  }

                  final newEnum = Enumerator(
                    id: enumerator.id,
                    name: name.value,
                    values: values.value,
                  );
                  controller.updateEnumerator(newEnum);
                  context.pop();
                },
                decoration: const InputDecoration(
                  labelText: 'Types',
                  hint: Text('Ex.: USER, ADMIN, GUEST'),
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
            ValueListenableBuilder(
              key: UniqueKey(),
              valueListenable: name,
              builder: (_, __, ___) {
                return ValueListenableBuilder(
                  key: UniqueKey(),
                  valueListenable: values,
                  builder: (_, __, ___) {
                    final tName = name.value.trim();
                    final tValues = values.value.trim();
                    final isInvalid = tName.isEmpty || tValues.isEmpty;
                    return TextButton(
                      onPressed: isInvalid
                          ? null
                          : () {
                              final newEnum = Enumerator(
                                id: enumerator.id,
                                name: name.value,
                                values: values.value,
                              );
                              controller.updateEnumerator(newEnum);
                              context.pop();
                            },
                      child: const Text('Create'),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
