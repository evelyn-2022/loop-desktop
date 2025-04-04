import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:loop/data/services/auth_token_manager.dart';
import 'package:loop/main.dart';
import 'package:loop/providers/auth_state.dart';
import 'package:loop/ui/splash/splash_screen.dart';

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() =>
      _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthState>();
    final tokenManager = context.read<AuthTokenManager>();
    _initFuture =
        authState.loadInitialAuthState(tokenManager);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState !=
            ConnectionState.done) {
          return const SplashScreen();
        }
        return const App();
      },
    );
  }
}
