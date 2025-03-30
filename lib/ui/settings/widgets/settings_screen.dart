import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:loop/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Settings', style: textTheme.headlineMedium),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text('Dark Mode',
                  style: textTheme.bodyMedium),
              Switch(
                value: isDarkMode,
                activeColor: colorScheme.primary,
                onChanged: (_) =>
                    themeProvider.toggleTheme(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
