import 'package:flutter/material.dart';
import 'package:loop/app_initializer.dart';
import 'providers/app_providers.dart';
import 'ui/shared/layout/desktop_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppProviders(child: AppInitializer()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const DesktopShell();
  }
}
