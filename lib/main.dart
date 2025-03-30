import 'package:flutter/material.dart';
import 'package:loop/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'config/dependencies.dart';
import 'routes/routes.dart';
import 'theme/app_theme.dart';
import 'ui/shared/layout/desktop_shell.dart';
import 'ui/auth/login/widgets/login_screen.dart';
import 'ui/auth/signup/widgets/signup_screen.dart';

void main() {
  runApp(const AppProviders(child: App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Loop',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.home,
            routes: {
              AppRoutes.home: (context) =>
                  const DesktopShell(),
              AppRoutes.login: (context) => LoginScreen(),
              AppRoutes.signup: (context) => SignupScreen(),
            },
          );
        },
      ),
    );
  }
}
