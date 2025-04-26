import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loop/data/services/oauth_service.dart';
import 'package:loop/theme/app_dimensions.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  void _handleGoogleLogin(BuildContext context) async {
    final oauthService = OAuthService();
    final code = await oauthService.loginWithGoogle();

    if (code != null) {
      // TODO: send code to backend
    } else {
      print('Login failed or canceled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: AppDimensions.dividerThickness,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(
                      AppDimensions.dividerThickness / 2),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text('or continue with'),
            ),
            Expanded(
              child: Container(
                height: AppDimensions.dividerThickness,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(
                      AppDimensions.dividerThickness / 2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.gapMd),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialIconButton(
              assetPath: 'assets/icons/google.svg',
              onPressed: () => _handleGoogleLogin(context),
            ),
            const SizedBox(width: AppDimensions.gapSm),
            _SocialIconButton(
              assetPath: 'assets/icons/apple.svg',
              onPressed: () => {},
            ),
            const SizedBox(width: AppDimensions.gapSm),
            _SocialIconButton(
              assetPath: 'assets/icons/google.svg',
              onPressed: () => {},
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;

  const _SocialIconButton({
    required this.assetPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor,
            width: AppDimensions.dividerThickness,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: SvgPicture.asset(
            assetPath,
            width: AppDimensions.iconSizeMd,
            height: AppDimensions.iconSizeMd,
            colorFilter: ColorFilter.mode(
              theme.colorScheme.primary,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
