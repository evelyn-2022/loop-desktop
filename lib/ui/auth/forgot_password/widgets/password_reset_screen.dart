import 'package:flutter/material.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/ui/shared/widgets/app_password_requirements.dart';
import 'package:loop/ui/shared/widgets/app_snack_bar.dart';
import 'package:loop/ui/shared/widgets/app_text_field.dart';
import 'package:loop/utils/validators.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() =>
      _PasswordResetScreenState();
}

class _PasswordResetScreenState
    extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();
  bool _submitAttempted = false;

  bool get hasMinLength =>
      _passwordController.text.length >= 8;
  bool get hasNumber =>
      _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get hasLowercase =>
      _passwordController.text.contains(RegExp(r'[a-z]'));

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() => _submitAttempted = true);

    if (_formKey.currentState?.validate() ?? false) {
      final newPassword = _passwordController.text.trim();
      // TODO: Call your viewmodel to reset the password
      // await context.read<ForgotPasswordViewModel>().resetPassword(newPassword);

      AppSnackBar.show(
        context,
        title: 'Password Reset Successful',
        type: SnackBarType.success,
      );

      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              maxWidth: AppDimensions.formWidth),
          child: Form(
            key: _formKey,
            child: Padding(
              padding:
                  const EdgeInsets.all(AppDimensions.gapMd),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Enter new password',
                      style: theme.textTheme.displayLarge),
                  const SizedBox(
                      height: AppDimensions.gapLg),
                  AppTextField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    label: 'Password',
                    hint: 'Enter new password',
                    obscure: true,
                    validator: Validators.validatePassword,
                    keyboardType:
                        TextInputType.visiblePassword,
                    visibleSvgAsset:
                        'assets/icons/eye_open.svg',
                    hiddenSvgAsset:
                        'assets/icons/eye_hidden.svg',
                    submitAttempted: _submitAttempted,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapSm),
                  AppPasswordRequirements(
                    hasMinLength: hasMinLength,
                    hasNumber: hasNumber,
                    hasLowercase: hasLowercase,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  AppButton(
                    label: 'Confirm',
                    onPressed: _handleSubmit,
                    isLoading:
                        false, // You can wire up loading from ViewModel
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
