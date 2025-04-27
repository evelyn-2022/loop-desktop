import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:loop/config/app_config.dart';
import 'package:loop/data/repositories/profile_repository.dart';
import 'package:loop/data/services/auth_token_manager.dart';
import 'package:loop/data/services/dio_interceptor.dart';
import 'package:loop/data/services/oauth_api_client.dart';
import 'package:loop/data/services/profile_api_client.dart';
import 'package:loop/providers/auth_state.dart';
import 'package:loop/providers/theme_provider.dart';
import 'package:loop/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:loop/ui/auth/oauth/view_modles/oauth_viewmodel.dart';
import 'package:loop/ui/auth/signup/view_models/signup_viewmodel.dart';
import 'package:loop/ui/profile/view_models/profile_viewmodel.dart';
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
        ChangeNotifierProvider<AuthState>(
          create: (_) => AuthState(),
        ),
        ProxyProvider2<AuthTokenManager, AuthState, Dio>(
          update: (_, tokenManager, authState, __) {
            final dio = Dio(
                BaseOptions(baseUrl: AppConfig.baseUrl));

            final authDio = Dio(
                BaseOptions(baseUrl: AppConfig.baseUrl));

            authDio.interceptors.add(LogInterceptor(
              requestBody: true,
              responseBody: true,
            ));
            dio.interceptors.add(LogInterceptor(
              requestBody: true,
              responseBody: true,
            ));

            dio.interceptors.add(
              DioInterceptor(
                tokenManager: tokenManager,
                authDio: authDio,
                authState: authState,
              ),
            );
            return dio;
          },
        ),
        Provider<AuthApiClient>(
          create: (_) => AuthApiClient(),
        ),
        Provider<OAuthApiClient>(
          create: (_) => OAuthApiClient(),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
            apiClient: context.read<AuthApiClient>(),
            oauthApiClient: context.read<OAuthApiClient>(),
            tokenManager: context.read<AuthTokenManager>(),
          ),
        ),
        ChangeNotifierProvider<LoginViewModel>(
          create: (context) => LoginViewModel(
            authRepository: context.read<AuthRepository>(),
            authState: context.read<AuthState>(),
          ),
        ),
        ChangeNotifierProvider<SignUpViewModel>(
          create: (context) => SignUpViewModel(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(),
        ),
        Provider<ProfileApiClient>(
          create: (context) =>
              ProfileApiClient(dio: context.read<Dio>()),
        ),
        Provider<ProfileRepository>(
          create: (context) => ProfileRepository(
              apiClient: context.read<ProfileApiClient>()),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (context) => ProfileViewModel(
              repository:
                  context.read<ProfileRepository>()),
        ),
        ChangeNotifierProvider<ForgotPasswordViewModel>(
          create: (context) => ForgotPasswordViewModel(
            authRepository: context.read<AuthRepository>(),
          ),
        ),
        ChangeNotifierProvider<OAuthViewModel>(
          create: (context) => OAuthViewModel(
            authRepository: context.read<AuthRepository>(),
            authState: context.read<AuthState>(),
          ),
        ),
      ],
      child: child,
    );
  }
}
