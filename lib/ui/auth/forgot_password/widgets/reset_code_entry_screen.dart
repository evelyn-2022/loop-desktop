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
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(6, (_) => FocusNode());
  bool _submitAttempted = false;

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
    super.dispose();
  }

  void _handleSubmit() async {
    setState(() => _submitAttempted = true);

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

    if (success) {
      Navigator.pushNamed(context, AppRoutes.resetPassword);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid reset code')),
      );
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
      return;
    }

    // Normal typing
    if (value.isNotEmpty) {
      _controllers[index].text = value[value.length -
          1]; // Only keep the last typed digit
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel =
        context.watch<ForgotPasswordViewModel>();

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
                          width: 48,
                          height: 48,
                          child: TextField(
                            controller:
                                _controllers[boxIndex],
                            focusNode:
                                _focusNodes[boxIndex],
                            keyboardType:
                                TextInputType.number,
                            textAlign: TextAlign.center,
                            style:
                                theme.textTheme.bodyMedium,
                            decoration:
                                const InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.all(8),
                            ),
                            onChanged: (value) =>
                                _onChanged(boxIndex, value),
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
                      Text("Didn't receive it? ",
                          style:
                              theme.textTheme.bodyMedium),
                      AppLink(
                        text: viewModel.isLoading
                            ? "Sending..."
                            : "Resend code",
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
    );
  }
}
