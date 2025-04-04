import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:loop/routes/routes.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';
import 'package:loop/providers/auth_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<AuthState>(
      builder: (context, authState, _) {
        final isLoggedIn = authState.isLoggedIn;
        final username =
            authState.currentUser?.username ?? 'Guest';

        return Scaffold(
          body: Center(
            child: isLoggedIn
                ? Text(
                    'Welcome, $username!',
                    style: textTheme.bodyMedium,
                  )
                : Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment:
                        WrapCrossAlignment.center,
                    children: [
                      AppLink(
                        text: 'Log in',
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.login);
                        },
                        fontSize:
                            textTheme.bodyMedium?.fontSize,
                      ),
                      Text(
                        ' to create your own music space',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
