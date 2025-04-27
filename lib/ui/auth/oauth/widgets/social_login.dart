import 'package:flutter/material.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/ui/auth/oauth/widgets/social_login_button.dart';
import 'package:loop/ui/shared/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:loop/data/services/oauth_service.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/auth/oauth/view_modles/oauth_viewmodel.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({super.key});

  void _handleGoogleLogin(BuildContext context) async {
    final oauthService = OAuthService();
    final oauthResponse =
        await oauthService.loginWithGoogle();

    if (oauthResponse == null) {
      AppSnackBar.show(
        context,
        title: 'Login Failed',
        body: 'Failed to receive authorization code.',
        type: SnackBarType.error,
      );
      return;
    }

    final code = oauthResponse.code;
    final redirectUri = oauthResponse.redirectUri;

    if (code.isEmpty || redirectUri.isEmpty) {
      AppSnackBar.show(
        context,
        title: 'Login Failed',
        body: 'Invalid OAuth response received.',
        type: SnackBarType.error,
      );
      return;
    }

    final viewModel = context.read<OAuthViewModel>();

    final success = await viewModel.oauthLogin(
      provider: 'GOOGLE',
      code: code,
      redirectUri: redirectUri,
    );

    AppSnackBar.show(
      context,
      title: success ? 'Login Successful' : 'Login Failed',
      body: success
          ? ''
          : viewModel.errorMessage ?? 'Unknown error.',
      type: success
          ? SnackBarType.success
          : SnackBarType.error,
    );

    if (success) {
      Navigator.pushReplacementNamed(
          context, AppRoutes.home);
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
            SocialLoginButton(
              assetPath: 'assets/icons/google.svg',
              onPressed: () => _handleGoogleLogin(context),
            ),
            const SizedBox(width: AppDimensions.gapSm),
            SocialLoginButton(
              assetPath: 'assets/icons/apple.svg',
              onPressed: () => {},
            ),
            const SizedBox(width: AppDimensions.gapSm),
            SocialLoginButton(
              assetPath: 'assets/icons/google.svg',
              onPressed: () => {},
            ),
          ],
        ),
      ],
    );
  }
}
