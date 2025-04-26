import 'package:flutter/material.dart';
import 'package:loop/theme/app_dimensions.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? width;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: AppDimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : onPressed, // Disable when loading
        child: isLoading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: AppDimensions.iconSizeXs,
                    height: AppDimensions.iconSizeXs,
                    child: CircularProgressIndicator(
                      strokeWidth:
                          AppDimensions.strokeWidthMd,
                      strokeCap: StrokeCap.round,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                        Theme.of(context)
                            .colorScheme
                            .onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(label),
                ],
              )
            : Text(label),
      ),
    );
  }
}
