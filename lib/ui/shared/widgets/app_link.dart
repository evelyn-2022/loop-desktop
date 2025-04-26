import 'package:flutter/material.dart';

class AppLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final double? fontSize;
  final bool isLoading;

  const AppLink({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
    this.fontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color ??
                  Theme.of(context).colorScheme.primary,
              fontSize: fontSize,
              decorationColor: color ??
                  Theme.of(context).colorScheme.primary,
            );

    return MouseRegion(
      cursor: isLoading
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
