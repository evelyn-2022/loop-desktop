import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:loop/providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final themeMode = themeProvider.themeMode;
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
              Text('Theme', style: textTheme.bodyMedium),
              DropdownButton<ThemeMode>(
                value: themeMode,
                onChanged: (ThemeMode? newMode) {
                  if (newMode != null) {
                    themeProvider.setThemeMode(newMode);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text('Light'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text('Dark'),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('System'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
