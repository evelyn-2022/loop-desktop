import 'package:flutter/material.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final themeProvider =
        Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to the Home Screen',
          style: textTheme.bodyMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.login);
        },
        backgroundColor: colorScheme.primary,
        child: const Icon(Icons.login),
      ),
    );
  }
}
