import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/application/entities/application.dart';
import 'package:metamorphis/src/presenter/_core/widgets/add_element_widget.dart';
import 'package:metamorphis/src/presenter/application/application_controller.dart';

class ApplicationPage extends StatefulWidget {
  const ApplicationPage({super.key});

  @override
  State<ApplicationPage> createState() => _ApplicationPageState();
}

class _ApplicationPageState extends State<ApplicationPage> {

  late final ApplicationController controller;

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
    final store = controller.applicationStore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final applications = store.applications;
            if (store.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                for (final application in applications)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _ApplicationCard(
                        application: application,
                        onTap: () {
                          controller.selectApplication(
                            application: application,
                            context: context,
                          );
                        },
                        onTapEdit: () {
                          showEditApplicationDialog(application);
                        }),
                  ),
                AddElementWidget(
                  onTap: () {
                    showCreateApplicationDialog();
                  },
                  text: 'Nova aplicação',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showCreateApplicationDialog() {
    final applicationName = ValueNotifier('');
    String applicationDescription = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova aplicação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                onChanged: (text) {
                  applicationName.value = text.trim();
                },
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (text) {
                  applicationDescription = text.trim();
                },
                decoration: const InputDecoration(
                  labelText: 'Descrição',
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
            ValueListenableBuilder(
              valueListenable: applicationName,
              builder: (_, name, __) {
                return TextButton(
                  onPressed: name.length > 2
                      ? () {
                    controller.saveApplication(
                      name: applicationName.value,
                      description: applicationDescription,
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

  void showEditApplicationDialog(Application application) {
    final applicationName = ValueNotifier(application.name);
    String applicationDescription = application.description;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar aplicação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                controller: TextEditingController(text: application.name),
                onChanged: (text) {
                  applicationName.value = text.trim();
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: application.description),
                onChanged: (text) {
                  applicationDescription = text.trim();
                },
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.pop();
                  showRemoveApplicationDialog(application);
                },
                child: Text(
                  'Remover este aplicação',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
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
            ValueListenableBuilder(
              valueListenable: applicationName,
              builder: (_, name, __) {
                return TextButton(
                  onPressed: name.length > 2
                      ? () {
                    application.name = applicationName.value;
                    application.description = applicationDescription;
                    controller.updateApplication(
                      application: application,
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

  void showRemoveApplicationDialog(Application application) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remover aplicação'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tem certeza que deseja remover o seguinte aplicação?'),
              const SizedBox(height: 8),
              Text(
                application.name,
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
                controller.deleteApplication(application: application);
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


class _ApplicationCard extends StatelessWidget {
  final Application application;
  final VoidCallback onTap;
  final VoidCallback onTapEdit;

  const _ApplicationCard({
    required this.application,
    required this.onTap,
    required this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 120,
      width: 160,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(
                    size: 16,
                    Icons.edit,
                  ),
                  onPressed: onTapEdit,
                  padding: EdgeInsets.zero,
                  iconSize: 16,
                  splashRadius: 10,
                ),
              ),
              Container(
                margin: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: Text(
                  application.name,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
