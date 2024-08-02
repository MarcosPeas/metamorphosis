import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final LoginController controller;

  @override
  void initState() {
    controller = GetIt.instance.get();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.init(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final store = controller.store;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Card(
            margin: EdgeInsets.zero,
            color: colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListenableBuilder(
                listenable: store,
                builder: (context, _) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Login',
                        style: textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        enabled: !store.loading,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        enabled: !store.loading,
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (store.error.message.isNotEmpty) ...[
                        Text(
                          'Verifique os dados informados',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      ElevatedButton(
                        onPressed: !store.loading
                            ? () {
                                controller.login(
                                  context: context,
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );
                              }
                            : null,
                        child: loginButtonChild(store.loading),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButtonChild(bool loading) {
    if (loading) {
      return const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          strokeWidth: 3,
        ),
      );
    }
    return const Text('Login');
  }
}
