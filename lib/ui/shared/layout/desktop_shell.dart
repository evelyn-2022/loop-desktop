import 'package:flutter/material.dart';
import 'package:loop/theme/app_theme.dart';

import 'package:loop/ui/home/widgets/home_screen.dart';
import 'package:loop/ui/search/widgets/search_screen.dart';
import 'package:loop/ui/library/widgets/library_screen.dart';
import 'package:loop/ui/settings/widgets/settings_screen.dart';
import 'package:loop/ui/profile/widgets/profile_screen.dart';
import 'package:loop/ui/shared/widgets/app_hover_tooltip.dart';

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
    const ProfileScreen(key: ValueKey('profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 70,
            child: Column(
              children: [
                const SizedBox(height: 12),
                _navIcon(0, Icons.home_outlined, Icons.home,
                    'Home'),
                _navIcon(1, Icons.search_outlined,
                    Icons.search, 'Search'),
                _navIcon(2, Icons.library_music_outlined,
                    Icons.library_music, 'Library'),
                _navIcon(3, Icons.settings_outlined,
                    Icons.settings, 'Settings'),
                const Spacer(),
                HoverTooltip(
                  icon: const Icon(Icons.person_outline),
                  message: 'Profile',
                  isSelected: _selectedIndex == 4,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                ),
              ],
            ),
          ),
          VerticalDivider(
              width: 2,
              color: Theme.of(context).dividerColor),
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

  Widget _navIcon(
    int index,
    IconData icon,
    IconData selectedIcon,
    String tooltip,
  ) {
    final isSelected = _selectedIndex == index;

    return HoverTooltip(
      icon: Icon(isSelected ? selectedIcon : icon),
      message: tooltip,
      isSelected: _selectedIndex == index,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
