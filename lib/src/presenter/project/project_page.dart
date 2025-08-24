import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/project/entities/project.dart';

import 'project_controller.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  late final ProjectController controller;

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
    final store = controller.projectStore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final projects = store.projects;
            if (store.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                for (final project in projects)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _ProjectCard(
                        project: project,
                        onTap: () {
                          controller.selectProject(
                            project: project,
                            context: context,
                          );
                        },
                        onTapEdit: () {
                          showEditProjectDialog(project);
                        }),
                  ),
                _AddElementWidget(
                  onTap: () {
                    showCreateProjectDialog();
                  },
                  text: 'New project',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showCreateProjectDialog() {
    final projectName = ValueNotifier('');
    String projectDescription = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New project'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                onChanged: (text) {
                  projectName.value = text.trim();
                },
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (text) {
                  projectDescription = text.trim();
                },
                decoration: const InputDecoration(
                  labelText: 'Description',
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
              valueListenable: projectName,
              builder: (_, name, __) {
                return TextButton(
                  onPressed: name.length > 2
                      ? () {
                          controller.saveProject(
                            name: projectName.value,
                            description: projectDescription,
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

  void showEditProjectDialog(Project project) {
    final projectName = ValueNotifier(project.name);
    String projectDescription = project.description;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit project'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                controller: TextEditingController(text: project.name),
                onChanged: (text) {
                  projectName.value = text.trim();
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: TextEditingController(text: project.description),
                onChanged: (text) {
                  projectDescription = text.trim();
                },
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.pop();
                  showRemoveProjectDialog(project);
                },
                child: Text(
                  'Remove this project',
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
              child: const Text('Cancel'),
            ),
            ValueListenableBuilder(
              valueListenable: projectName,
              builder: (_, name, __) {
                return TextButton(
                  onPressed: name.length > 2
                      ? () {
                          project.name = projectName.value;
                          project.description = projectDescription;
                          controller.updateProject(
                            project: project,
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

  void showRemoveProjectDialog(Project project) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove project'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to remove the following project?'),
              const SizedBox(height: 8),
              Text(
                project.name,
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
                controller.deleteProject(project: project);
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

class _AddElementWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const _AddElementWidget({required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: 160,
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add,
                  size: 42,
                ),
                const SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onTapEdit;

  const _ProjectCard({
    required this.project,
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
                  project.name,
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
