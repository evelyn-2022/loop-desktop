import 'package:flutter/material.dart';
import 'package:loop/theme/app_dimensions.dart';

class PasswordRequirements extends StatelessWidget {
  final bool hasMinLength;
  final bool hasNumber;
  final bool hasLowercase;

  const PasswordRequirements({
    super.key,
    required this.hasMinLength,
    required this.hasNumber,
    required this.hasLowercase,
  });

  Widget _buildItem(
      BuildContext context, bool met, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor =
        met ? colorScheme.primary : Colors.grey;
    final textColor =
        met ? colorScheme.onSurface : Colors.grey;

    return Row(
      children: [
        Icon(
          met
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          size: 16,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
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
