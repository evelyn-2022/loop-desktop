import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loop/theme/app_colors.dart';
import 'package:loop/theme/app_dimensions.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? visibleSvgAsset;
  final String? hiddenSvgAsset;
  final Key? fieldKey;
  final bool autofocus;
  final FocusNode? focusNode;
  final KeyEventResult Function(KeyEvent)? onKeyEvent;
  final bool submitAttempted;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.visibleSvgAsset,
    this.hiddenSvgAsset,
    this.fieldKey,
    this.autofocus = false,
    this.focusNode,
    this.onKeyEvent,
    this.submitAttempted = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  bool _wasTouched = false;
  bool _showError = false;
  String _lastValue = '';
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _obscureText = widget.obscure;
    _focusNode = widget.focusNode ?? FocusNode();
    _lastValue = widget.controller.text;

    _focusNode.addListener(_handleFocusChange);
    widget.controller.addListener(_handleTextChanged);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus &&
        (_wasTouched || widget.submitAttempted)) {
      _validateAndShowError();
    }
  }

  void _handleTextChanged() {
    final currentValue = widget.controller.text;

    if (!_wasTouched &&
        _focusNode.hasFocus &&
        currentValue != _lastValue) {
      _wasTouched = true;
    }

    if (_showError && currentValue != _lastValue) {
      setState(() => _showError = false);
    }

    _lastValue = currentValue;
  }

  void _validateAndShowError() {
    final error =
        widget.validator?.call(widget.controller.text);
    if (mounted) {
      setState(() {
        _errorMessage = error;
        _showError = error != null;
      });
    }
  }

  @override
  void didUpdateWidget(covariant AppTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!_focusNode.hasFocus &&
        widget.submitAttempted &&
        !_showError) {
      _validateAndShowError();
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChanged);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: AppDimensions.textFieldHeight,
          child: TextFormField(
            key: widget.fieldKey,
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            obscureText: _obscureText,
            style: theme.textTheme.bodyMedium,
            autofocus: widget.autofocus,
            validator: (_) => null,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              suffixIcon: widget.obscure
                  ? IconButton(
                      onPressed: _toggleVisibility,
                      icon: _buildVisibilityIcon(),
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(
          height: 16,
          child: Padding(
            padding: const EdgeInsets.only(
              left:
                  AppDimensions.textFieldPaddingHorizontal,
              top: 2,
            ),
            child: AnimatedOpacity(
              opacity: _showError && _errorMessage != null
                  ? 1
                  : 0,
              duration: const Duration(milliseconds: 150),
              child: Text(
                _errorMessage ?? '',
                style: TextStyle(
                  color: AppColors.red_200,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityIcon() {
    final isVisible = !_obscureText;
    final assetPath = isVisible
        ? widget.visibleSvgAsset
        : widget.hiddenSvgAsset;

    if (assetPath == null) return const SizedBox.shrink();

    final color = _focusNode.hasFocus
        ? AppColors.grey_300
        : Theme.of(context).iconTheme.color!;

    return SvgPicture.asset(
      assetPath,
      width: AppDimensions.iconSizeSm,
      height: AppDimensions.iconSizeSm,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
