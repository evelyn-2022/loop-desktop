import 'package:flutter/material.dart';
import 'package:loop/theme/app_dimensions.dart';

class ProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(
                horizontal: AppDimensions.strokeWidthLg),
            height: AppDimensions.strokeWidthLg,
            decoration: BoxDecoration(
              color: isActive
                  ? colorScheme.primary
                  : colorScheme.outline,
              borderRadius: BorderRadius.circular(
                  AppDimensions.buttonBorderRadius),
            ),
          ),
        );
      }),
    );
  }
}
