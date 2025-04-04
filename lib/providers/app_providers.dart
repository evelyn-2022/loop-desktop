import 'package:flutter/material.dart';
import 'package:loop/data/services/auth_token_manager.dart';
import 'package:loop/providers/auth_state.dart';
import 'package:loop/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:loop/data/repositories/auth_repository.dart';
import 'package:loop/data/services/auth_api_client.dart';
import 'package:loop/ui/auth/login/view_models/login_viewmodel.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthTokenManager>(
          create: (_) => AuthTokenManager(),
        ),
        Provider<AuthApiClient>(
          create: (_) => AuthApiClient(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            apiClient: context.read<AuthApiClient>(),
            tokenManager: context.read<AuthTokenManager>(),
          ),
        ),
        ChangeNotifierProvider<AuthState>(
          create: (_) => AuthState(),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(
            authRepository: context.read<AuthRepository>(),
            authState: context.read<AuthState>(),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: child,
    );
  }
}
