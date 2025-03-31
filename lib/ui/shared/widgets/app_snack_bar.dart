import 'package:flutter/material.dart';
import 'package:loop/theme/app_colors.dart';

enum SnackBarType { success, error }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.success,
    double horizontalOffset = 0.0,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final borderColor = type == SnackBarType.success
        ? AppColors.green_600
        : colorScheme.error;

    // Clear any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: 16,
        child: Transform.translate(
          offset: Offset(horizontalOffset, 0),
          child: Center(
            child: Material(
              elevation: 3,
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 360,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border(
                    bottom: BorderSide(
                      color: borderColor,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  message,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () {
      entry.remove();
    });
  }
}
