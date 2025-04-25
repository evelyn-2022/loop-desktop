import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';
import 'package:provider/provider.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/ui/auth/forgot_password/view_models/forgot_password_viewmodel.dart';

class ResetCodeEntryScreen extends StatefulWidget {
  const ResetCodeEntryScreen({super.key});

  @override
  State<ResetCodeEntryScreen> createState() =>
      _ResetCodeEntryScreenState();
}

class _ResetCodeEntryScreenState
    extends State<ResetCodeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _resetCodeController = TextEditingController();
  final _resetCodeFocus = FocusNode();
  final _keyboardListenerFocus = FocusNode();
  bool _submitAttempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetCodeFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _resetCodeController.dispose();
    _resetCodeFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() => _submitAttempted = true);
    if (_formKey.currentState?.validate() ?? false) {
      final resetCode = _resetCodeController.text.trim();

      final viewModel =
          context.read<ForgotPasswordViewModel>();

      final success =
          await viewModel.verifyResetCode(resetCode);

      if (success) {
        // Navigate to the next screen if the code is correct
        Navigator.pushNamed(
            context,
            AppRoutes
                .resetPassword); // Navigate to the password reset screen
      } else {
        // Show error message if the code is incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid reset code')),
        );
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
          child: SingleChildScrollView(
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
                        'Enter reset code',
                        style: theme.textTheme.displayLarge,
                      ),
                      const SizedBox(
                          height: AppDimensions.gapXl),
                      Text(
                        'Enter the 6-digit code sent to your email',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(
                          height: AppDimensions.gapMd),
                      TextFormField(
                        controller: _resetCodeController,
                        decoration: const InputDecoration(
                          labelText: 'Reset Code',
                          hintText: 'Enter reset code',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if ((_submitAttempted ||
                                  value?.isNotEmpty ==
                                      true) &&
                              (value?.length != 6 ||
                                  int.tryParse(
                                          value ?? '') ==
                                      null)) {
                            return 'Please enter a valid 6-digit code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                          height: AppDimensions.gapSm),
                      AppButton(
                        label: 'Verify code',
                        onPressed: _handleSubmit,
                        isLoading: viewModel.isLoading,
                      ),
                      const SizedBox(
                          height: AppDimensions.gapMd),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text("Didn't receive it? ",
                              style: theme
                                  .textTheme.bodyMedium),
                          AppLink(
                            text: viewModel.isLoading
                                ? "Sending..."
                                : "Resend code",
                            color: (viewModel.isLoading)
                                ? theme
                                    .colorScheme.secondary
                                : null,
                            onTap: () {
                              if (!viewModel.isLoading) {
                                // viewModel.resendResetCode();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
