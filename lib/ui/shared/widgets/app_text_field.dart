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
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _hasFocus = false;
  bool _showError = false;

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
            focusNode: _focusNode,
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
            onTap: () {
              if (widget.fieldKey
                  is GlobalKey<FormFieldState<String>>) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) {
                  setState(() {
                    // Update error message when tapped
                    if (_showError) {
                      errorMessage = widget.validator
                          ?.call(widget.controller.text);
                    }
                  });

                  final currentPosition =
                      widget.controller.selection;
                  widget.controller.selection =
                      currentPosition;
                });
              }
            },
          ),
        ),
        // Separate container for error display with fixed height
        SizedBox(
          height: 16, // Fixed height for error area
          child: Padding(
            padding: const EdgeInsets.only(
                left: AppDimensions
                    .textFieldPaddingHorizontal,
                top: 2),
            child: errorMessage != null
                ? Text(
                    errorMessage!,
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
        _hasFocus ? activeIconColor : baseIconColor!,
        BlendMode.srcIn,
      ),
    );
  }
}
