import 'package:flutter/material.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("New here? ",
                style: theme.textTheme.bodyMedium),
            AppLink(
              text: "Create an account",
              onTap: () => Navigator.pushNamed(
                  context, AppRoutes.signup),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.gapSm),
        AppLink(
          text: "Continue as guest",
          color: theme.colorScheme.secondary,
          fontSize: 14,
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.home),
        ),
      ],
    );
  }
}
