import 'package:flutter/material.dart';
import 'package:loop/theme/app_colors.dart';

enum SnackBarType { success, error }

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String title,
    String? body,
    SnackBarType type = SnackBarType.success,
    double horizontalOffset = 0.0,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final borderColor = type == SnackBarType.success
        ? AppColors.green_600
        : colorScheme.error;

    final icon = type == SnackBarType.success
        ? Icons.check_circle_outline
        : Icons.error_outline;

    final iconColor = borderColor;

    // Clear any existing snackbars
    ScaffoldMessenger.of(context).clearSnackBars();

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: 20,
        child: Transform.translate(
          offset: Offset(horizontalOffset, 0),
          child: Center(
            child: Material(
              color: colorScheme.surface,
              elevation: 2,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: 360,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: borderColor,
                      width: 4,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      color: iconColor,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium,
                          ),
                          if (body != null &&
                              body != '') ...[
                            const SizedBox(height: 4),
                            Text(
                              body,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
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
