import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/presenter/_core/extensions/navigator_extension.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';
import 'package:metamorphis/src/presenter/home/references/references_page.dart';
import 'package:metamorphis/src/presenter/home/home_controller.dart';
import 'package:metamorphis/src/presenter/home/widgets/dialog_change_target_widget.dart';
import 'package:metamorphis/src/presenter/home/widgets/selected_entity_widget.dart';
import 'package:metamorphis/src/presenter/project/project_routers.dart';

import 'entity_rules/entity_rules_page.dart';
import 'use_cases/use_cases_page.dart';
import 'value_objects/value_objects_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;

  @override
  void initState() {
    controller = GetIt.instance();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appStore = controller.appStore;
    final homeStore = controller.homeStore;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        body: ListenableBuilder(
          listenable: appStore,
          builder: (_, __) {
            if (homeStore.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            final entity = appStore.entity;
            if (entity == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No entity',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        showCreateEntityDialog();
                      },
                      child: const Text('Create entity'),
                    ),
                  ],
                ),
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListenableBuilder(
                  listenable: homeStore,
                  builder: (context, _) {
                    return Container(
                      width: 200,
                      height: double.infinity,
                      color: colorScheme.primaryContainer,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ColoredBox(
                            color: colorScheme.primaryContainer,
                            child: _MenuWidget(
                              entity: entity,
                              onTap: () {
                                showEntitiesOptionsDialog(entity);
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          _MenuItems(
                            index: homeStore.page,
                            onTap: (index) {
                              controller.pageController.jumpToPage(index);
                              homeStore.page = index;
                            },
                          ),
                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Options',
                              style: textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                          _MenuItem(
                            title: 'Projects',
                            selected: false,
                            onTap: () => context.pushNamedAndRemoveUntil(
                              ProjectRouters.projects,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                showDialogSelectTarget();
                              },
                              child: const Text('Generate Code'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PageView(
                      controller: controller.pageController,
                      children: [
                        ValueObjectsPage(
                          entity: entity,
                          key: ValueKey(entity.id),
                        ),
                        ReferencesPage(
                          entities: homeStore.entities,
                          key: ValueKey(entity.id),
                        ),
                        EntityRulesPage(key: ValueKey(entity.id)),
                        UseCasesPage(key: ValueKey(entity.id)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showDialogSelectTarget() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change target'),
          content: DialogSelectTargetWidget(controller: controller),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void showEntitiesOptionsDialog(EntityViewModel entity) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text('Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Add entity'),
                onTap: () {
                  context.pop();
                  showCreateEntityDialog();
                },
                leading: const Icon(Icons.add),
              ),
              ListTile(
                title: const Text('Edit entity'),
                onTap: () {
                  context.pop();
                  showEditEntityDialog(entity);
                },
                leading: const Icon(Icons.edit),
              ),
              ListTile(
                title: const Text('Change to another entity'),
                onTap: () {
                  context.pop();
                  showSelectEntityDialog(entity);
                },
                leading: const Icon(Icons.change_circle),
              ),
              ListTile(
                title: Text(
                  'Remover entity',
                  style: TextStyle(color: colorScheme.error),
                ),
                onTap: () {
                  context.pop();
                  showDeleteEntityDialog(entity);
                },
                leading: Icon(Icons.delete, color: colorScheme.error),
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
          ],
        );
      },
    );
  }

  void showSelectEntityDialog(EntityViewModel entity) {
    final homeStore = controller.homeStore;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select entity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final tempEntity in homeStore.entities)
                ListTile(
                  enabled: tempEntity.id != entity.id,
                  title: Text(tempEntity.name),
                  onTap: () {
                    controller.selectEntity(entity: tempEntity);
                    context.pop();
                  },
                  trailing: const Icon(Icons.chevron_right),
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
          ],
        );
      },
    );
  }

  void showCreateEntityDialog() {
    final applicationName = ValueNotifier('');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New entity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onSubmitted: (value) {
                  if (applicationName.value.length > 2) {
                    controller.saveEntity(name: applicationName.value);
                    context.pop();
                  }
                },
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (text) {
                  applicationName.value = text.trim();
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
            ValueListenableBuilder(
              valueListenable: applicationName,
              builder: (_, name, __) {
                return TextButton(
                  onPressed: name.length > 2
                      ? () {
                          controller.saveEntity(name: applicationName.value);
                          context.pop();
                        }
                      : null,
                  child: const Text('Save'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showEditEntityDialog(EntityViewModel entity) {
    final applicationName = ValueNotifier(entity.name);
    final nameController = TextEditingController(text: entity.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit entity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onSubmitted: (value) {
                  if (applicationName.value.length > 2) {
                    controller.updateEntity(
                      entity: entity.copyWith(name: applicationName.value),
                    );
                    context.pop();
                  }
                },
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (text) {
                  applicationName.value = text.trim();
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
            ValueListenableBuilder(
              valueListenable: applicationName,
              builder: (_, name, __) {
                return TextButton(
                  onPressed: name.length > 2
                      ? () {
                          controller.updateEntity(
                            entity: entity.copyWith(
                              name: applicationName.value,
                            ),
                          );
                          context.pop();
                        }
                      : null,
                  child: const Text('Save'),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void showDeleteEntityDialog(EntityViewModel entity) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove entity'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to remove the following entity?',
              ),
              const SizedBox(height: 8),
              Text(
                entity.name,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
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
                controller.deleteEntity(entity: entity);
                context.pop();
              },
              child: Text('Remove', style: TextStyle(color: colorScheme.error)),
            ),
          ],
        );
      },
    );
  }
}

class _MenuWidget extends StatelessWidget {
  final EntityViewModel entity;
  final VoidCallback onTap;

  const _MenuWidget({required this.entity, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          SelectedEntityWidget(entity: entity, onTap: onTap),
        ],
      ),
    );
  }
}

class _MenuItems extends StatelessWidget {
  final int index;
  final void Function(int index) onTap;

  const _MenuItems({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _MenuItem(
          title: 'Value Objects',
          selected: index == 0,
          onTap: () => onTap(0),
        ),
        _MenuItem(
          title: 'References',
          selected: index == 1,
          onTap: () => onTap(1),
        ),
        _MenuItem(
          title: 'Entity Rules',
          selected: index == 2,
          onTap: () => onTap(2),
        ),
        _MenuItem(
          title: 'Use Cases',
          selected: index == 3,
          onTap: () => onTap(3),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final bool selected;
  final void Function()? onTap;
  final String title;

  const _MenuItem({
    required this.selected,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final primary = colorScheme.primary;
    final onPrimary = colorScheme.onPrimary;
    final primaryContainer = colorScheme.primaryContainer;
    final onPrimaryContainer = colorScheme.onPrimaryContainer;
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? primary : primaryContainer,
        foregroundColor: selected ? onPrimary : onPrimaryContainer,
        enableFeedback: false,
        textStyle: textTheme.titleMedium,
        alignment: Alignment.centerLeft,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      ),
      child: Text(title),
    );
  }
}
