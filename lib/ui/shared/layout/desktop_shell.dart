import 'package:flutter/material.dart';
import 'package:loop/ui/auth/login/widgets/login_screen.dart';

import 'package:loop/ui/home/widgets/home_screen.dart';
import 'package:loop/ui/search/widgets/search_screen.dart';
import 'package:loop/ui/settings/widgets/settings_screen.dart';

class DesktopShell extends StatefulWidget {
  const DesktopShell({super.key});

  @override
  State<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends State<DesktopShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const LoginScreen(key: ValueKey('login')),
    const SearchScreen(key: ValueKey('search')),
    const SettingsScreen(key: ValueKey('settings')),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: colorScheme.surface,
            selectedIconTheme:
                IconThemeData(color: colorScheme.primary),
            unselectedIconTheme: IconThemeData(
                color:
                    colorScheme.onSurface.withOpacity(0.6)),
            selectedLabelTextStyle: TextStyle(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelTextStyle: TextStyle(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.search_outlined),
                selectedIcon: Icon(Icons.search),
                label: Text('Search'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          )
        ],
      ),
    );
  }
}
