import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
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
  final _passwordFocus = FocusNode();
  final _keyboardListenerFocus = FocusNode();
  bool _submitAttempted = false;

  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasLowercase = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _passwordFocus.requestFocus();
    });

    _passwordController
        .addListener(_updatePasswordRequirements);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordFocus.dispose();
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  void _updatePasswordRequirements() {
    final text = _passwordController.text;
    setState(() {
      _hasMinLength = text.length >= 8;
      _hasNumber = RegExp(r'\d').hasMatch(text);
      _hasLowercase = RegExp(r'[a-z]').hasMatch(text);
    });
  }

  void _handleSubmit() async {
    setState(() => _submitAttempted = true);

    final viewModel =
        context.read<ForgotPasswordViewModel>();
    final newPassword = _passwordController.text.trim();

    final isFormValid =
        Validators.validatePassword(newPassword) == null;

    if (!isFormValid || viewModel.isLoading) {
      _keyboardListenerFocus.requestFocus();
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final success = await context
          .read<ForgotPasswordViewModel>()
          .resetPassword(newPassword);

      AppSnackBar.show(
        context,
        title: success
            ? 'Password Reset Successful'
            : 'Password Reset Failed',
        type: success
            ? SnackBarType.success
            : SnackBarType.error,
      );

      if (success) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.login, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel =
        context.watch<ForgotPasswordViewModel>();

    return Scaffold(
      body: Focus(
        focusNode: _keyboardListenerFocus,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey ==
                  LogicalKeyboardKey.enter) {
            _handleSubmit();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: AppDimensions.formWidth),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(
                    AppDimensions.gapMd),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Enter new password',
                        style:
                            theme.textTheme.displayLarge),
                    const SizedBox(
                        height: AppDimensions.gapLg),
                    AppTextField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      label: 'Password',
                      hint: 'Enter new password',
                      obscure: true,
                      validator:
                          Validators.validatePassword,
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
                      hasMinLength: _hasMinLength,
                      hasNumber: _hasNumber,
                      hasLowercase: _hasLowercase,
                    ),
                    const SizedBox(
                        height: AppDimensions.gapMd),
                    AppButton(
                      label: 'Confirm',
                      onPressed: _handleSubmit,
                      isLoading: viewModel.isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
