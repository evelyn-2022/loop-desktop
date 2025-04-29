import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loop/theme/app_dimensions.dart';

class SocialLoginButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;
  final String? text;

  const SocialLoginButton({
    super.key,
    required this.assetPath,
    required this.onPressed,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: AppDimensions.buttonHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.dividerColor,
            width: AppDimensions.dividerThickness,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: AppDimensions.iconSizeSm,
              height: AppDimensions.iconSizeSm,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              text ?? 'Your text here',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
