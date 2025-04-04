import 'package:flutter/material.dart';

class HoverTooltip extends StatefulWidget {
  final Widget icon;
  final String message;
  final VoidCallback onTap;
  final bool isSelected;

  const HoverTooltip({
    super.key,
    required this.icon,
    required this.message,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  State<HoverTooltip> createState() => _HoverTooltipState();
}

class _HoverTooltipState extends State<HoverTooltip> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showTooltip() {
    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(50, 8),
          showWhenUnlinked: false,
          child: Material(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 200,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.message,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;

    return CompositedTransformTarget(
      link: _layerLink,
      child: MouseRegion(
        onEnter: (_) => _showTooltip(),
        onExit: (_) => _hideTooltip(),
        child: IconButton(
          onPressed: widget.onTap,
          icon: widget.icon,
          color: color,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          style: ButtonStyle(
            overlayColor:
                WidgetStateProperty.all(Colors.transparent),
            backgroundColor:
                WidgetStateProperty.all(Colors.transparent),
            padding:
                WidgetStateProperty.all(EdgeInsets.zero),
            minimumSize:
                WidgetStateProperty.all(const Size(48, 48)),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
    );
  }
}
