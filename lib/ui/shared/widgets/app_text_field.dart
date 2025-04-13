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
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  bool _showError = false;
  late VoidCallback _controllerListener;
  late String _lastValue;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
    _focusNode = widget.focusNode ?? FocusNode();
    _lastValue = widget.controller.text;

    _focusNode.addListener(() {
      setState(() {
        if (!_focusNode.hasFocus) {
          _showError = true;
        }
      });
    });

    _controllerListener = () {
      final currentValue = widget.controller.text;

      if (_focusNode.hasFocus &&
          _showError &&
          currentValue != _lastValue) {
        setState(() {
          _showError = false;
        });
      }

      _lastValue = currentValue;
    };

    widget.controller.addListener(_controllerListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_controllerListener);
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.obscure;

    String? errorMessage;
    if (_showError) {
      errorMessage =
          widget.validator?.call(widget.controller.text);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: AppDimensions.textFieldHeight,
          child: TextFormField(
            key: widget.fieldKey,
            controller: widget.controller,
            obscureText: _obscureText,
            keyboardType: widget.keyboardType,
            validator: (_) => null,
            focusNode: widget.focusNode ?? _focusNode,
            style: Theme.of(context).textTheme.bodyMedium,
            autofocus: widget.autofocus,
            decoration: InputDecoration(
              labelText: widget.label,
              hintText: widget.hint,
              suffixIcon: isPassword
                  ? IconButton(
                      onPressed: _toggleVisibility,
                      icon: _obscureText
                          ? _buildSvgIcon(
                              widget.hiddenSvgAsset)
                          : _buildSvgIcon(
                              widget.visibleSvgAsset),
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
            child: errorMessage != null
                ? Text(
                    errorMessage,
                    style: TextStyle(
                      color: AppColors.red_200,
                      fontSize: 12,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildSvgIcon(String? assetPath) {
    final baseIconColor = Theme.of(context).iconTheme.color;
    final activeIconColor = AppColors.grey_300;

    if (assetPath == null) return const SizedBox.shrink();
    return SvgPicture.asset(
      assetPath,
      width: AppDimensions.iconSizeSm,
      height: AppDimensions.iconSizeSm,
      colorFilter: ColorFilter.mode(
        _focusNode.hasFocus
            ? activeIconColor
            : baseIconColor!,
        BlendMode.srcIn,
      ),
    );
  }
}
