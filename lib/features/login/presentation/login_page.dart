import 'package:city_guide_app/features/login/presentation/login_screen.dart';
import 'package:city_guide_app/src/application/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_guide_app/features/debug/debug_page.dart';

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
