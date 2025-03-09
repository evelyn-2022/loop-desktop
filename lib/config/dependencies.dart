// lib/config/providers.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:babelbeats/data/repositories/auth_repository.dart';
import 'package:babelbeats/data/services/auth_api_client.dart';
import 'package:babelbeats/ui/auth/login/view_models/login_viewmodel.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authApiClient = AuthApiClient();
    final authRepository =
        AuthRepository(apiClient: authApiClient);

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
