import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:metamorphis/src/domain/bounded_context/entities/bounded_context.dart';

import 'bounded_context_controller.dart';

class BoundedContextPage extends StatefulWidget {
  const BoundedContextPage({super.key});

  @override
  State<BoundedContextPage> createState() => _BoundedContextPageState();
}

class _BoundedContextPageState extends State<BoundedContextPage> {
  late final BoundedContextController controller;

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
    final store = controller.boundedContextStore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projetos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final boundedContexts = store.boundedContexts;
            if (store.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              children: [
                for (final boundedContext in boundedContexts)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _BoundedContextCard(
                        boundedContext: boundedContext,
                        onTap: () {
                          controller.selectBoundedContext(
                            boundedContext: boundedContext,
                            context: context,
                          );
                        },
                        onTapEdit: () {
                          showEditBoundedContextDialog(boundedContext);
                        }),
                  ),
                _AddElementWidget(
                  onTap: () {
                    showCreateBoundedContextDialog();
                  },
                  text: 'Novo contexto delimitado',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showCreateBoundedContextDialog() {
    final boundedContextName = ValueNotifier('');
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Novo contexto delimitado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                onChanged: (text) {
                  boundedContextName.value = text.trim();
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
              valueListenable: boundedContextName,
              builder: (_, name, __) {
                return TextButton(
                  onPressed: name.length > 2
                      ? () {
                          controller.saveBoundedContext(
                            name: boundedContextName.value,
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

  void showEditBoundedContextDialog(BoundedContext boundedContext) {
    final boundedContextName = ValueNotifier(boundedContext.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar contexto delimitado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
                controller: TextEditingController(text: boundedContext.name),
                onChanged: (text) {
                  boundedContextName.value = text.trim();
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  context.pop();
                  showRemoveBoundedContextDialog(boundedContext);
                },
                child: Text(
                  'Remover este contexto delimitado',
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
              valueListenable: boundedContextName,
              builder: (_, name, __) {
                return TextButton(
                  onPressed: name.length > 2
                      ? () {
                          boundedContext.name = boundedContextName.value;
                          controller.updateBoundedContext(
                            boundedContext: boundedContext,
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

  void showRemoveBoundedContextDialog(BoundedContext boundedContext) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remover contexto delimitado'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tem certeza que deseja remover o seguinte contexto delimitado?'),
              const SizedBox(height: 8),
              Text(
                boundedContext.name,
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
                controller.deleteBoundedContext(boundedContext: boundedContext);
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

class _BoundedContextCard extends StatelessWidget {
  final BoundedContext boundedContext;
  final VoidCallback onTap;
  final VoidCallback onTapEdit;

  const _BoundedContextCard({
    required this.boundedContext,
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
                  boundedContext.name,
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
