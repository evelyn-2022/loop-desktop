import 'package:flutter/material.dart';
import 'package:loop/theme/app_dimensions.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: AppDimensions.strokeWidthMd,
          strokeCap: StrokeCap.round,
          valueColor: AlwaysStoppedAnimation<Color>(
            colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
