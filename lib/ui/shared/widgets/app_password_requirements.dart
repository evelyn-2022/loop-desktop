import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loop/theme/app_dimensions.dart';

class AppPasswordRequirements extends StatelessWidget {
  final bool hasMinLength;
  final bool hasNumber;
  final bool hasLowercase;

  const AppPasswordRequirements({
    super.key,
    required this.hasMinLength,
    required this.hasNumber,
    required this.hasLowercase,
  });

  Widget _buildItem(
      BuildContext context, bool met, String text) {
    final theme = Theme.of(context);
    final textColor = met
        ? theme.colorScheme.onSurface
        : theme.textTheme.bodySmall!.color;

    return Row(
      children: [
        SvgPicture.asset(
          met
              ? 'assets/icons/checked_circle.svg'
              : 'assets/icons/circle.svg',
          width: AppDimensions.iconSizeXs,
          height: AppDimensions.iconSizeXs,
          colorFilter: ColorFilter.mode(
            met
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: AppDimensions.gapXs),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: theme.textTheme.bodySmall!.fontSize,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildItem(
            context, hasMinLength, "At least 8 characters"),
        const SizedBox(height: AppDimensions.gapXs),
        _buildItem(context, hasNumber, "Contains a number"),
        const SizedBox(height: AppDimensions.gapXs),
        _buildItem(context, hasLowercase,
            "Contains a lowercase letter"),
      ],
    );
  }
}
