import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loop/theme/app_dimensions.dart';

class SocialLoginButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
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
