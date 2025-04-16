import 'package:flutter/material.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Already have an account? ",
                style: theme.textTheme.bodyMedium),
            AppLink(
              text: "Log in",
              onTap: () =>
                  Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.gapMd),
        AppLink(
          text: "Continue as guest",
          fontSize: 14,
          color: theme.colorScheme.secondary,
          onTap: () => Navigator.pushReplacementNamed(
              context, '/home'),
        ),
      ],
    );
  }
}
