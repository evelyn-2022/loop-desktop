import 'package:flutter/material.dart';
import 'config/dependencies.dart';
import 'routes/routes.dart';
import 'ui/home/widgets/home_screen.dart';
import 'ui/auth/login/widgets/login_screen.dart';
import 'ui/auth/signup/widgets/signup_screen.dart';

void main() {
  runApp(const AppProviders(child: App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner:
          false, // Disable debug banner
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => HomeScreen(),
        AppRoutes.login: (context) => LoginScreen(),
        AppRoutes.signup: (context) => SignupScreen(),
      },
    );
  }
}
