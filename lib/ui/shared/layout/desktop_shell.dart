import 'package:flutter/material.dart';

import 'package:loop/ui/home/widgets/home_screen.dart';
import 'package:loop/ui/search/widgets/search_screen.dart';
import 'package:loop/ui/library/widgets/library_screen.dart';
import 'package:loop/ui/settings/widgets/settings_screen.dart';
import 'package:loop/ui/profile/widgets/profile_screen.dart';

class DesktopShell extends StatefulWidget {
  const DesktopShell({super.key});

  @override
  State<DesktopShell> createState() => _DesktopShellState();
}

class _DesktopShellState extends State<DesktopShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(key: ValueKey('home')),
    const SearchScreen(key: ValueKey('search')),
    const LibraryScreen(key: ValueKey('library')),
    const SettingsScreen(key: ValueKey('settings')),
    const Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 80,
            child: Column(
              children: [
                Expanded(
                  child: NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    backgroundColor: colorScheme.onPrimary,
                    indicatorColor: Colors.transparent,
                    selectedIconTheme: IconThemeData(
                        color: colorScheme.primary),
                    unselectedIconTheme: IconThemeData(
                        color: colorScheme.secondary),
                    selectedLabelTextStyle: TextStyle(
                        color: colorScheme.primary),
                    unselectedLabelTextStyle: TextStyle(
                        color: colorScheme.secondary),
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
                        icon: Icon(
                            Icons.library_music_outlined),
                        selectedIcon:
                            Icon(Icons.library_music),
                        label: Text('Library'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings_outlined),
                        selectedIcon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(
                            Icons.unfold_more_outlined),
                        selectedIcon:
                            Icon(Icons.unfold_more),
                        label: Text('Expand'),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 16),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const ProfileScreen()),
                      );
                    },
                    icon: const Icon(Icons.person_outline),
                    tooltip: 'Profile',
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _screens,
            ),
          ),
        ],
      ),
    );
  }
}
