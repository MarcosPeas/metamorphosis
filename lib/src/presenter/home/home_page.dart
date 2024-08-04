import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/presenter/_core/view_models/entity_view_model.dart';
import 'package:metamorphis/src/presenter/home/home_controller.dart';
import 'package:metamorphis/src/presenter/home/widgets/selected_entity_widget.dart';

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
    return Scaffold(
      body: ListenableBuilder(
        listenable: appStore,
        builder: (_, __) {
          if (homeStore.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
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
                    'Nenhuma entidade',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showCreateEntityDialog();
                    },
                    child: const Text('Criar entidade'),
                  ),
                ],
              ),
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 200,
                child: _MenuWidget(
                  entity: entity,
                  onTap: () {
                    showEntitiesOptionsDialog(entity);
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.red,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showEntitiesOptionsDialog(EntityViewModel entity) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: const Text('Opções'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Adicionar entidade'),
                onTap: () {
                  context.pop();
                  showCreateEntityDialog();
                },
                leading: const Icon(Icons.add),
              ),
              ListTile(
                title: const Text('Editar entidade'),
                onTap: () {
                  context.pop();
                  showEditEntityDialog(entity);
                },
                leading: const Icon(Icons.edit),
              ),
              ListTile(
                title: const Text('Mudar para outra entidade'),
                onTap: () {
                  context.pop();
                  showSelectEntityDialog(entity);
                },
                leading: const Icon(Icons.change_circle),
              ),
              ListTile(
                title: Text(
                  'Remover entidade',
                  style: TextStyle(
                    color: colorScheme.error,
                  ),
                ),
                onTap: () {
                  context.pop();
                  showDeleteEntityDialog(entity);
                },
                leading: Icon(
                  Icons.delete,
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancelar'),
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
          title: const Text('Selecionar entidade'),
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
              child: const Text('Cancelar'),
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
          title: const Text('Nova entidade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onSubmitted: (value) {
                  if (applicationName.value.length > 2) {
                    controller.saveEntity(
                      name: applicationName.value,
                    );
                    context.pop();
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
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
              child: const Text('Cancelar'),
            ),
            ValueListenableBuilder(
              valueListenable: applicationName,
              builder: (_, name, __) {
                return TextButton(
                  onPressed: name.length > 2
                      ? () {
                          controller.saveEntity(
                            name: applicationName.value,
                          );
                          context.pop();
                        }
                      : null,
                  child: const Text('Salvar'),
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
          title: const Text('Editar entidade'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onSubmitted: (value) {
                  if (applicationName.value.length > 2) {
                    controller.saveEntity(
                      name: applicationName.value,
                    );
                    context.pop();
                  }
                },
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
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
              child: const Text('Cancelar'),
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
                  child: const Text('Salvar'),
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
          title: const Text('Remover entidade'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tem certeza que deseja remover a seguinte entidade?'),
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
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                controller.deleteEntity(entity: entity);
                context.pop();
              },
              child: Text(
                'Remover',
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

class _MenuWidget extends StatelessWidget {
  final EntityViewModel entity;
  final VoidCallback onTap;

  const _MenuWidget({
    required this.entity,
    required this.onTap,
  });

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
