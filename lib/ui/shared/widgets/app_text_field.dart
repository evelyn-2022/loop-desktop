import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loop/theme/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? visibleSvgAsset;
  final String? hiddenSvgAsset;

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
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
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
      height: 48,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _obscureText,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        focusNode: _focusNode,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: widget.hint,
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: _toggleVisibility,
                  icon: _obscureText
                      ? _buildSvgIcon(widget.hiddenSvgAsset)
                      : _buildSvgIcon(
                          widget.visibleSvgAsset),
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSvgIcon(String? assetPath) {
    final baseIconColor = Theme.of(context).iconTheme.color;
    final activeIconColor = AppColors.grey_300;

    if (assetPath == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SvgPicture.asset(
        assetPath,
        width: 20,
        height: 20,
        colorFilter: ColorFilter.mode(
          _hasFocus ? activeIconColor : baseIconColor!,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
