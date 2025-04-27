import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:loop/providers/auth_state.dart';
import 'package:loop/theme/app_dimensions.dart';
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

  List<Widget> get _screens => [
        const HomeScreen(key: ValueKey('home')),
        const SearchScreen(key: ValueKey('search')),
        const LibraryScreen(key: ValueKey('library')),
        const SettingsScreen(key: ValueKey('settings')),
        ProfileScreen(
          key: ValueKey('profile'),
          shouldLoad: _selectedIndex == 4,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final profileUrl = authState.currentUser?.profileUrl;

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: AppDimensions.navBarWidth,
            child: Column(
              children: [
                const SizedBox(
                    height:
                        AppDimensions.pagePaddingVertical),
                Column(
                  children: [
                    _navIcon(
                      0,
                      'assets/icons/home_outlined.svg',
                      'assets/icons/home_filled.svg',
                      'Home',
                    ),
                    const SizedBox(
                        height: AppDimensions
                            .navBarIconSizespacing),
                    _navIcon(
                      1,
                      'assets/icons/search_outlined.svg',
                      'assets/icons/search_filled.svg',
                      'Search',
                    ),
                    const SizedBox(
                        height: AppDimensions
                            .navBarIconSizespacing),
                    _navIcon(
                      2,
                      'assets/icons/library_outlined.svg',
                      'assets/icons/library_filled.svg',
                      'Library',
                    ),
                    const SizedBox(
                        height: AppDimensions
                            .navBarIconSizespacing),
                    _navIcon(
                      3,
                      'assets/icons/setting_outlined.svg',
                      'assets/icons/setting_filled.svg',
                      'Settings',
                    ),
                  ],
                ),
                const Spacer(),
                HoverTooltip(
                  icon: profileUrl != null
                      ? CircleAvatar(
                          radius:
                              AppDimensions.navBarIconSize /
                                  2,
                          backgroundImage:
                              NetworkImage(profileUrl),
                          backgroundColor:
                              Colors.transparent,
                        )
                      : SvgPicture.asset(
                          'assets/icons/profile_guest.svg',
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == 4
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                : Theme.of(context)
                                    .colorScheme
                                    .secondary,
                            BlendMode.srcIn,
                          ),
                          width:
                              AppDimensions.navBarIconSize,
                          height:
                              AppDimensions.navBarIconSize,
                        ),
                  message: 'Profile',
                  isSelected: _selectedIndex == 4,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  },
                ),
                const SizedBox(
                    height:
                        AppDimensions.pagePaddingVertical),
              ],
            ),
          ),
          VerticalDivider(
              width: AppDimensions.dividerThickness,
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
    String iconPath,
    String selectedIconPath,
    String tooltip,
  ) {
    final isSelected = _selectedIndex == index;
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    return HoverTooltip(
      icon: SvgPicture.asset(
        isSelected ? selectedIconPath : iconPath,
        colorFilter:
            ColorFilter.mode(color, BlendMode.srcIn),
        width: AppDimensions.navBarIconSize,
        height: AppDimensions.navBarIconSize,
      ),
      message: tooltip,
      isSelected: isSelected,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}
