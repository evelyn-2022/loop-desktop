// lib/config/providers.dart

import 'package:flutter/material.dart';
import 'package:loop/data/services/auth_token_manager.dart';
import 'package:provider/provider.dart';
import 'package:loop/data/repositories/auth_repository.dart';
import 'package:loop/data/services/auth_api_client.dart';
import 'package:loop/ui/auth/login/view_models/login_viewmodel.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authApiClient = AuthApiClient();
    final authRepository = AuthRepository(
        apiClient: authApiClient,
        tokenManager: AuthTokenManager());

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(
          create: (_) => LoginViewModel(
              authRepository: authRepository),
        ),
      ],
      child: child,
    );
  }
}
