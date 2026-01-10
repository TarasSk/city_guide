import 'package:city_guide_app/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);

    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: size.height * 0.4,
              color: theme.colorScheme.primaryContainer,
            ),
            Expanded(
              child: Container(color: Colors.white),
            ),
          ],
        ),
        Align(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              elevation: 6,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton.icon(
                      onPressed: () => context.read<AuthBloc>()
                        ..add(const AuthEvent.loginWithGoogleRequested()),
                      icon: const Icon(Icons.g_mobiledata),
                      label: const Text('Continue with Google'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        side: const BorderSide(color: Colors.grey),
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Or login with',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 16),

                    // Email.
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Password.
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.visibility_off),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Remember me + Forgot Password.
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: (_) {}),
                        const Text('Remember me'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password ?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Login Button.
                    FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Log In'),
                    ),
                    const SizedBox(height: 16),

                    // Sign up link.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don’t have an account?'),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
