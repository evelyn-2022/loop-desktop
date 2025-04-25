import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';
import 'package:loop/ui/shared/widgets/app_snack_bar.dart';
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
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());
  final _keyboardListenerFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final resetCode =
        _controllers.map((c) => c.text).join();

    if (resetCode.length != 6 ||
        int.tryParse(resetCode) == null) {
      // Invalid input
      return;
    }

    final viewModel =
        context.read<ForgotPasswordViewModel>();

    final success =
        await viewModel.verifyResetCode(resetCode);

    AppSnackBar.show(
      context,
      title: success
          ? viewModel.successMessage!
          : 'Cannot verify code',
      body: success ? '' : viewModel.errorMessage,
      type: success
          ? SnackBarType.success
          : SnackBarType.error,
    );

    if (success) {
      Navigator.pushNamed(context, AppRoutes.resetPassword);
    }
  }

  void _onChanged(int index, String value) {
    if (value.length > 1) {
      // User pasted multiple characters
      final digits = value.split('');
      for (var i = 0;
          i < digits.length && (index + i) < 6;
          i++) {
        _controllers[index + i].text = digits[i];
      }
      final nextIndex = (index + digits.length) < 6
          ? (index + digits.length)
          : 5;
      _focusNodes[nextIndex].requestFocus();

      // Auto-submit after paste
      if (_controllers.every((c) => c.text.isNotEmpty)) {
        _handleSubmit();
      }

      return;
    }

    // Normal typing
    if (value.isNotEmpty) {
      _controllers[index].text = value[value.length - 1];
      if (index < _focusNodes.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    // Auto submit after manual input
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _handleSubmit();
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
          if (event is KeyDownEvent) {
            final key = event.logicalKey;

            // Enter submits
            if (key == LogicalKeyboardKey.enter) {
              _handleSubmit();
              return KeyEventResult.handled;
            }

            // Left/Right arrow navigation
            final currentIndex =
                _focusNodes.indexWhere((n) => n.hasFocus);
            if (key == LogicalKeyboardKey.arrowLeft &&
                currentIndex > 0) {
              _focusNodes[currentIndex - 1].requestFocus();
              return KeyEventResult.handled;
            } else if (key ==
                    LogicalKeyboardKey.arrowRight &&
                currentIndex < 5) {
              _focusNodes[currentIndex + 1].requestFocus();
              return KeyEventResult.handled;
            }
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
                    Row(
                      children:
                          List.generate(6 * 2 - 1, (index) {
                        if (index.isOdd) {
                          return const Spacer();
                        }
                        final boxIndex = index ~/ 2;
                        return SizedBox(
                            width: AppDimensions
                                .textFieldHeight,
                            height: AppDimensions
                                .textFieldHeight,
                            child: TextField(
                              controller:
                                  _controllers[boxIndex],
                              focusNode:
                                  _focusNodes[boxIndex],
                              keyboardType:
                                  TextInputType.number,
                              textAlign: TextAlign.center,
                              style: theme
                                  .textTheme.bodyMedium,
                              decoration:
                                  const InputDecoration(
                                counterText: '',
                                border:
                                    OutlineInputBorder(),
                                contentPadding:
                                    EdgeInsets.all(8),
                              ),
                              onChanged: (value) =>
                                  _onChanged(
                                      boxIndex, value),
                              inputFormatters: [
                                FilteringTextInputFormatter
                                    .digitsOnly,
                              ],
                            ));
                      }),
                    ),
                    const SizedBox(
                        height: AppDimensions.gapMd),
                    AppButton(
                      label: 'Verify Code',
                      onPressed: _handleSubmit,
                      isLoading: viewModel.isLoading,
                    ),
                    const SizedBox(
                        height: AppDimensions.gapMd),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Text("Didn't receive the code? ",
                            style:
                                theme.textTheme.bodyMedium),
                        AppLink(
                          text: viewModel.isLoading
                              ? "Sending..."
                              : "Resend",
                          color: (viewModel.isLoading)
                              ? theme.colorScheme.secondary
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
    );
  }
}
