import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loop/theme/app_colors.dart';

enum SnackBarType { success, error }

class AppSnackBar {
  static OverlayEntry? _currentSnackbar;
  static Timer? _hideTimer;
  static bool _isHovered = false;

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

    _currentSnackbar?.remove();
    _hideTimer?.cancel();
    _currentSnackbar = null;

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        bottom: 20,
        child: Transform.translate(
          offset: Offset(horizontalOffset, 0),
          child: Center(
            child: MouseRegion(
              onEnter: (_) {
                _isHovered = true;
                _hideTimer?.cancel();
              },
              onExit: (_) {
                _isHovered = false;
                _startAutoHide();
              },
              child: Material(
                color: colorScheme.surface,
                elevation: 2,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 360,
                    maxWidth: 600,
                  ),
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
                  child: IntrinsicWidth(
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          color: iconColor,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium,
                              ),
                              if (body != null &&
                                  body.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  body,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                  softWrap: true,
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
        ),
      ),
    );

    overlay.insert(entry);
    _currentSnackbar = entry;

    _startAutoHide();
  }

  static void _startAutoHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (!_isHovered) {
        _currentSnackbar?.remove();
        _currentSnackbar = null;
      } else {
        _startAutoHide();
      }
    });
  }
}
