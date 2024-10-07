import 'package:flutter/material.dart';
import 'package:metamorphis/src/presenter/home/home_controller.dart';
import 'package:metamorphis/src/presenter/home/widgets/dialog_change_target_store.dart';

class DialogChangeTargetWidget extends StatelessWidget {
  late final DialogChangeTargetStore store;
  late final PageController pageController;
  final HomeController controller;

  DialogChangeTargetWidget({super.key, required this.controller}) {
    store = DialogChangeTargetStore();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 320,
      child: ListenableBuilder(
        listenable: store,
        builder: (_, __) {
          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Flutter'),
                    onTap: () {
                      store.target = 'flutter';
                      pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const ListTile(
                    title: Text('Rust GraphQL'),
                    enabled: false,
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
              _ChangeOption(
                controller: controller,
                store: store,
                pageController: pageController,
                onTapBack: () {
                  pageController.animateToPage(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                title: 'Flutter',
                children: [
                  const ListTile(
                    title: Text('Rest'),
                    trailing: Icon(Icons.chevron_right),
                    enabled: false,
                  ),
                  const ListTile(
                    title: Text('GraphQL'),
                    trailing: Icon(Icons.chevron_right),
                    enabled: false,
                  ),
                  ListTile(
                    title: const Text('Supabase'),
                    onTap: () {
                      store.target = 'Supabase';
                      pageController.animateToPage(
                        2,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              _SupabaseOption(
                controller: controller,
                store: store,
                pageController: pageController,
                onTapBack: () {
                  pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ChangeOption extends StatelessWidget {
  final void Function() onTapBack;
  final String title;
  final List<Widget> children;
  final DialogChangeTargetStore store;
  final PageController pageController;
  final HomeController controller;

  const _ChangeOption({
    required this.onTapBack,
    required this.children,
    required this.title,
    required this.pageController,
    required this.store,
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
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        ...children,
      ],
    );
  }
}

class _SupabaseOption extends StatelessWidget {
  final void Function() onTapBack;
  final DialogChangeTargetStore store;
  final PageController pageController;
  final HomeController controller;
  final urlProd = ValueNotifier<String>('');
  final anoKeyProd = ValueNotifier<String>('');
  final urlDev = ValueNotifier<String>('');
  final anoKeyDev = ValueNotifier<String>('');

  _SupabaseOption({
    required this.onTapBack,
    required this.pageController,
    required this.store,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return _ChangeOption(
      onTapBack: onTapBack,
      title: 'Flutter: Supabase',
      store: store,
      pageController: pageController,
      controller: controller,
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'https://your-project.supabase.co',
            label: Text('Supabase URL (Production)'),
          ),
          onChanged: (value) {
            urlProd.value = value;
          },
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            hintText: 'your-anon-key',
            label: Text('Supabase Anon Key (Production)'),
          ),
          onChanged: (value) {
            anoKeyProd.value = value;
          },
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            hintText: 'https://your-project.supabase.co',
            label: Text('Supabase URL (Production)'),
          ),
          onChanged: (value) {
            urlDev.value = value;
          },
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            hintText: 'your-anon-key',
            label: Text('Supabase Anon Key (Production)'),
          ),
          onChanged: (value) {
            anoKeyDev.value = value;
          },
        ),
        const SizedBox(height: 24),
        ValueListenableBuilder(
          valueListenable: urlProd,
          builder: (_, urlProValue, __) {
            return ValueListenableBuilder(
              valueListenable: anoKeyProd,
              builder: (_, keyProdValue, __) {
                final enabled = urlProValue.isNotEmpty && keyProdValue.isNotEmpty;
                return ElevatedButton(
                  onPressed: enabled ?() {
                    controller.buildFlutterWidthSupabase(
                      supabaseUrlProd: urlProd.value,
                      anonKeyProd: anoKeyProd.value,
                      supabaseUrlDev: urlDev.value,
                      anonKeyDev: anoKeyDev.value,
                    );
                  } : null,
                  child: const Text('Generate Code'),
                );
              }
            );
          }
        ),
      ],
    );
  }
}
