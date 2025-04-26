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
  final _keyboardListenerFocus = FocusNode();
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes.first.requestFocus();
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final n in _focusNodes) n.dispose();
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final resetCode =
        _controllers.map((c) => c.text).join();
    if (resetCode.length != 6 ||
        int.tryParse(resetCode) == null) return;

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
      final digits = value.split('');
      for (var i = 0;
          i < digits.length && index + i < 6;
          i++) {
        _controllers[index + i].text = digits[i];
      }
      final next = (index + digits.length < 6)
          ? index + digits.length
          : 5;
      _focusNodes[next].requestFocus();
    } else {
      if (value.isNotEmpty) {
        _controllers[index].text = value[value.length - 1];
        if (index < 5)
          _focusNodes[index + 1].requestFocus();
        else
          _focusNodes[index].unfocus();
      } else if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _handleSubmit();
    }
  }

  KeyEventResult _handleKeyEvent(
      FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent)
      return KeyEventResult.ignored;

    final key = event.logicalKey;
    final currentIndex =
        _focusNodes.indexWhere((n) => n.hasFocus);

    if (key == LogicalKeyboardKey.enter) {
      _handleSubmit();
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowLeft &&
        currentIndex > 0) {
      _focusNodes[currentIndex - 1].requestFocus();
      return KeyEventResult.handled;
    } else if (key == LogicalKeyboardKey.arrowRight &&
        currentIndex < 5) {
      _focusNodes[currentIndex + 1].requestFocus();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Widget buildCodeInputRow(ThemeData theme) {
    return Row(
      children: List.generate(6 * 2 - 1, (i) {
        if (i.isOdd) return const Spacer();
        final index = i ~/ 2;
        return SizedBox(
          width: AppDimensions.textFieldHeight,
          height: AppDimensions.textFieldHeight,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
            decoration: const InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ],
            onChanged: (value) => _onChanged(index, value),
          ),
        );
      }),
    );
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
        onKeyEvent: _handleKeyEvent,
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
                    Text('Enter reset code',
                        style:
                            theme.textTheme.displayLarge),
                    const SizedBox(
                        height: AppDimensions.gapLg),
                    Text(
                        'Enter the 6-digit code sent to your email',
                        style: theme.textTheme.bodyMedium),
                    const SizedBox(
                        height: AppDimensions.gapMd),
                    buildCodeInputRow(theme),
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
                          text: viewModel.isResending
                              ? 'Sending...'
                              : 'Resend',
                          color: viewModel.isResending
                              ? theme.colorScheme.secondary
                              : null,
                          onTap: () {
                            if (!viewModel.isResending) {
                              viewModel.resendResetCode();
                            }
                          },
                          isLoading: viewModel.isResending,
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
