import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loop/theme/app_dimensions.dart';

class SignUpTopBar extends StatelessWidget {
  final int currentStep;
  final List<String> stepInstructions;
  final VoidCallback onBack;

  const SignUpTopBar({
    super.key,
    required this.currentStep,
    required this.stepInstructions,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (currentStep > 0)
          IconButton(
            onPressed: onBack,
            icon: SvgPicture.asset(
              'assets/icons/chevron.svg',
              width: AppDimensions.iconSizeXs,
              height: AppDimensions.iconSizeXs,
              colorFilter: ColorFilter.mode(
                theme.colorScheme.onSurface,
                BlendMode.srcIn,
              ),
            ),
          ),
        const SizedBox(width: AppDimensions.gapXs),
        Text(
          stepInstructions[currentStep],
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}
