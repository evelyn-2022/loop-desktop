import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/ui/shared/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';
import 'package:loop/ui/shared/widgets/app_text_field.dart';
import 'package:loop/utils/validators.dart';

class EmailEntryScreen extends StatefulWidget {
  const EmailEntryScreen({super.key});

  @override
  State<EmailEntryScreen> createState() =>
      _EmailEntryScreenState();
}

class _EmailEntryScreenState
    extends State<EmailEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  final _keyboardListenerFocus = FocusNode();
  bool _submitAttempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
  }

  void _handleSubmit() async {
    setState(() => _submitAttempted = true);
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();

      final viewModel =
          context.read<ForgotPasswordViewModel>();

      final isFormValid =
          Validators.validateEmail(email) == null;

      if (!isFormValid || viewModel.isLoading) {
        _keyboardListenerFocus.requestFocus();
        return;
      }

      final success =
          await viewModel.requestPasswordReset(email);

      AppSnackBar.show(
        context,
        title: success
            ? viewModel.successMessage!
            : 'Cannot reset password',
        body: success ? '' : viewModel.errorMessage,
        type: success
            ? SnackBarType.success
            : SnackBarType.error,
      );

      if (success) {
        Navigator.pushNamed(context, AppRoutes.verifyCode);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
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
                    Text(
                      'Forgot password',
                      style: theme.textTheme.displayLarge,
                    ),
                    const SizedBox(
                        height: AppDimensions.gapLg),
                    Text(
                      'Enter your email to get a 6-digit reset code',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(
                        height: AppDimensions.gapMd),
                    AppTextField(
                      key: const ValueKey('email'),
                      controller: _emailController,
                      focusNode: _emailFocus,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType:
                          TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      submitAttempted: _submitAttempted,
                    ),
                    const SizedBox(
                        height: AppDimensions.gapMd),
                    AppButton(
                      label: 'Send Code',
                      onPressed: _handleSubmit,
                      isLoading: viewModel.isLoading,
                    ),
                    const SizedBox(
                        height: AppDimensions.gapMd),
                    AppLink(
                        text: 'Back to login',
                        color: theme.colorScheme.secondary,
                        fontSize: 14,
                        onTap: () => Navigator.pop(context))
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
