import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
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
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
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
