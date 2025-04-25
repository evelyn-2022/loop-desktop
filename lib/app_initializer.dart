import 'package:flutter/material.dart';
import 'package:loop/ui/auth/forgot_password/widgets/email_entry_screen.dart';
import 'package:loop/ui/auth/forgot_password/widgets/reset_code_entry_screen.dart';
import 'package:provider/provider.dart';

import 'data/services/auth_token_manager.dart';
import 'main.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_state.dart';
import 'routes/routes.dart';
import 'theme/app_theme.dart';
import 'ui/shared/layout/desktop_shell.dart';
import 'ui/auth/login/widgets/login_screen.dart';
import 'ui/auth/signup/widgets/signup_screen.dart';
import 'ui/splash/splash_screen.dart';

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
    final themeProvider = context.watch<ThemeProvider>();

    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        final showSplash = snapshot.connectionState !=
            ConnectionState.done;

        return MaterialApp(
          title: 'Loop',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: showSplash
              ? const SplashScreen()
              : const App(),
          routes: {
            AppRoutes.login: (context) => LoginScreen(),
            AppRoutes.signup: (context) => SignUpScreen(),
            AppRoutes.home: (context) =>
                const DesktopShell(),
            AppRoutes.forgotPassword: (context) =>
                const EmailEntryScreen(),
            AppRoutes.verifyCode: (context) =>
                const ResetCodeEntryScreen(),
            AppRoutes.resetPassword: (context) =>
                const EmailEntryScreen(),
          },
        );
      },
    );
  }
}
