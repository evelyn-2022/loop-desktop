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
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  bool _showError = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;

        if (_focusNode.hasFocus) {
          _showError = false;
        } else {
          _showError = true;
        }
      });
    });
  }

  @override
  void dispose() {
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

    return SizedBox(
      width: double.infinity,
      height: AppDimensions.textFieldHeight,
      child: TextFormField(
        key: widget.fieldKey,
        controller: widget.controller,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        validator: (value) {
          if (!_showError) {
            return null;
          }
          return widget.validator?.call(value);
        },
        focusNode: _focusNode,
        style: Theme.of(context).textTheme.bodyMedium,
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
            helperText: ' '), // Prevents jumping
        onTap: () {
          // Clear validation error without triggering selection
          if (widget.fieldKey
              is GlobalKey<FormFieldState<String>>) {
            // Schedule this after the tap has been processed
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
              (widget.fieldKey
                      as GlobalKey<FormFieldState<String>>)
                  .currentState
                  ?.validate();

              // Maintain cursor position instead of selecting all text
              final currentPosition =
                  widget.controller.selection;
              widget.controller.selection = currentPosition;
            });
          }
        },
      ),
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
        _hasFocus ? activeIconColor : baseIconColor!,
        BlendMode.srcIn,
      ),
    );
  }
}
