import 'package:flutter/material.dart';

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
            icon: const Icon(Icons.chevron_left),
            onPressed: onBack,
          ),
        Text(
          stepInstructions[currentStep],
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
