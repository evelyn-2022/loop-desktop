import 'package:flutter/material.dart';
import 'package:loop/ui/shared/widgets/app_text_field.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/utils/validators.dart';

class SignupScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppTextField(
              controller: _emailController,
              label: 'Email',
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _passwordController,
              label: 'Password',
              hint: 'Enter your password',
              obscure: true,
              keyboardType: TextInputType.visiblePassword,
              validator: Validators.validatePassword,
            ),
            const SizedBox(height: 24),
            AppButton(
              label: 'Sign Up',
              onPressed: () {
                // Handle sign up logic
                print('Email: ${_emailController.text}');
                print(
                    'Password: ${_passwordController.text}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
