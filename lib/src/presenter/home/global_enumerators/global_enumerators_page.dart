import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/domain/global_enumerator/entities/global_enumerator.dart';
import 'package:metamorphis/src/presenter/_core/utils/custom_input_formatters.dart';

import 'global_enumerators_controller.dart';

class GlobalEnumeratorsPage extends StatefulWidget {
  const GlobalEnumeratorsPage({super.key});

  @override
  State<GlobalEnumeratorsPage> createState() => _GlobalEnumeratorsPageState();
}

class _GlobalEnumeratorsPageState extends State<GlobalEnumeratorsPage> {
  late final GlobalEnumeratorsController controller;

  @override
  void initState() {
    controller = GetIt.I.get();
    controller.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final store = controller.store;
    final textTheme = Theme.of(context).textTheme;
    final application = controller.application;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'Global Enumerators',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: () => _showDialogCreateEnumerator(application),
              icon: Icon(color: colorScheme.primary, Icons.add, size: 22),
            ),
          ],
        ),
        Expanded(
          child: ListenableBuilder(
            listenable: store,
            builder: (context, _) {
              if (store.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              final enumerators = store.enumerators;
              if (enumerators.isEmpty) {
                return const Center(child: Text('No enumerators found.'));
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: enumerators.length,
                itemBuilder: (_, index) {
                  final enumerator = enumerators[index];
                  return _GlobalEnumeratorWidget(
                    enumerator: enumerator,
                    onEditTap: () {
                      _showDialogUpdateEnumerator(enumerator);
                    },
                    onDeleteTap: () {
                      _showDialogDeleteEnumerator(enumerator);
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

  void _showDialogCreateEnumerator(Application application) {
    final enumeratorNotifier = ValueNotifier(
      GlobalEnumerator.withApplication(application),
    );
    showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: enumeratorNotifier,
          builder: (_, enumerator, ___) {
            return AlertDialog(
              title: const Text('Create a enumerator'),
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
                      if (enumerator.requirementsAreCompleted) {
                        controller.createEnumerator(enumerator);
                        context.pop();
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (text) {
                      if (text.isEmpty) {
                        return;
                      }
                      enumeratorNotifier.value = enumerator.copyWith(
                        description: text.trim(),
                      );
                    },
                    onSubmitted: (text) {
                      if (enumerator.requirementsAreCompleted) {
                        controller.createEnumerator(enumerator);
                        context.pop();
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Values',
                      hint: Text('Ex.: RED, GREEN, DARK_BLUE'),
                    ),
                    inputFormatters: [
                      CustomInputFormatters.onlyAZ09AndUnderscore,
                    ],
                    onChanged: (text) {
                      enumerator.addValues(text.trim());
                      enumeratorNotifier.value = enumerator.clone();
                    },
                    onSubmitted: (text) {
                      if (enumerator.requirementsAreCompleted) {
                        controller.createEnumerator(enumerator);
                        context.pop();
                      }
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
                  onPressed: enumerator.requirementsAreCompleted
                      ? () {
                          controller.createEnumerator(enumerator);
                          context.pop();
                        }
                      : null,
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDialogUpdateEnumerator(GlobalEnumerator enumerator) {
    final enumeratorNotifier = ValueNotifier(enumerator);
    final nameController = TextEditingController(text: enumerator.name);
    final descriptionController = TextEditingController(
      text: enumerator.description,
    );
    final valuesController = TextEditingController(text: enumerator.values);
    showDialog(
      context: context,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: enumeratorNotifier,
          builder: (_, enumerator, ___) {
            return AlertDialog(
              title: const Text('Create a enumerator'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
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
                      if (enumerator.requirementsAreCompleted) {
                        controller.updateEnumerator(enumerator);
                        context.pop();
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (text) {
                      if (text.isEmpty) {
                        return;
                      }
                      enumeratorNotifier.value = enumerator.copyWith(
                        description: text.trim(),
                      );
                    },
                    onSubmitted: (text) {
                      if (enumerator.requirementsAreCompleted) {
                        controller.updateEnumerator(enumerator);
                        context.pop();
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: valuesController,
                    decoration: const InputDecoration(
                      labelText: 'Values',
                      hint: Text('Ex.: RED, GREEN, DARK_BLUE'),
                    ),
                    inputFormatters: [
                      CustomInputFormatters.onlyAZ09AndUnderscore,
                    ],
                    onChanged: (text) {
                      enumerator.addValues(text.trim());
                      enumeratorNotifier.value = enumerator.clone();
                    },
                    onSubmitted: (text) {
                      if (enumerator.requirementsAreCompleted) {
                        controller.updateEnumerator(enumerator);
                        context.pop();
                      }
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
                  onPressed: enumerator.requirementsAreCompleted
                      ? () {
                          controller.updateEnumerator(enumerator);
                          context.pop();
                        }
                      : null,
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDialogDeleteEnumerator(GlobalEnumerator enumerator) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text('Attention'),
          content: RichText(
            text: TextSpan(
              text: 'Do you want to remove: ',
              children: [
                TextSpan(
                  text: enumerator.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: enumerator.requirementsAreCompleted
                  ? () {
                      controller.deleteEnumerator(enumerator);
                      context.pop();
                    }
                  : null,
              child: Text(
                'Delete',
                style: TextStyle(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GlobalEnumeratorWidget extends StatelessWidget {
  final GlobalEnumerator enumerator;
  final VoidCallback onEditTap;
  final VoidCallback onDeleteTap;

  const _GlobalEnumeratorWidget({
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
        Text(enumerator.values),
        const SizedBox(height: 16),
      ],
    );
  }
}
