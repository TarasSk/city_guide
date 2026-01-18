import 'package:core/core.dart';
import 'package:debug/debug.dart';

import 'package:flutter/material.dart';
import 'package:login/login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void onPresed(BuildContext context) {
    final bloc = context.watch<ThemeBloc>();
    switch (bloc.state) {
      case ThemeDark():
        bloc.add(const ThemeEvent.setLightTheme());
      case ThemeLight():
        bloc.add(const ThemeEvent.setDarkTheme());
      case _:
        bloc.add(const ThemeEvent.setSystemTheme());
    }
  }

  void _showDebugPage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const DebugPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const LoginScreen(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.bug_report),
        onPressed: () => _showDebugPage(context),
      ),
    );
  }
}
