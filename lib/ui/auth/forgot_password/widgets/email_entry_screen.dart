import 'package:flutter/material.dart';
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
  bool _submitAttempted = false;

  void _handleSubmit() {
    setState(() => _submitAttempted = true);
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();

      // Replace this with your actual logic
      // context
      //     .read<PasswordRecoveryViewModel>()
      //     .sendResetCode(email);

      // Navigator.pushNamed(context, AppRoutes.verifyCode);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Forgot Password',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Enter your email to receive a 6-digit reset code.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      child: const Text('Send Code'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppLink(
                      text: 'Back to login',
                      onTap: () => Navigator.pop(context))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
