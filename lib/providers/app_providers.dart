import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:loop/config/app_config.dart';
import 'package:loop/data/repositories/profile_repository.dart';
import 'package:loop/data/services/auth_token_manager.dart';
import 'package:loop/data/services/dio_interceptor.dart';
import 'package:loop/data/services/profile_api_client.dart';
import 'package:loop/providers/auth_state.dart';
import 'package:loop/providers/theme_provider.dart';
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
        ProxyProvider<AuthTokenManager, Dio>(
          update: (_, tokenManager, __) {
            final dio = Dio(
                BaseOptions(baseUrl: AppConfig.baseUrl));

            final authDio = Dio(
                BaseOptions(baseUrl: AppConfig.baseUrl));
            authDio.options.extra['withCredentials'] = true;
            final cookieJar = CookieJar();
            authDio.interceptors
                .add(CookieManager(cookieJar));

            dio.interceptors.add(
              DioInterceptor(
                tokenManager: tokenManager,
                authDio: authDio,
              ),
            );
            return dio;
          },
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
      ],
      child: child,
    );
  }
}
