import 'package:flutter/material.dart';
import 'config/dependencies.dart';
import 'ui/auth/login/widgets/login_screen.dart';

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
      home: LoginScreen(),
    );
  }
}
