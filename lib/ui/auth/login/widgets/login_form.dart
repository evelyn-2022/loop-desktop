import 'package:flutter/material.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';
import 'package:loop/ui/shared/widgets/app_text_field.dart';
import 'package:loop/utils/validators.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final bool submitAttempted;
  final VoidCallback onSubmit;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.submitAttempted,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: formKey,
      child: Column(
        children: [
          AppTextField(
            key: const ValueKey('email'),
            controller: emailController,
            focusNode: emailFocus,
            label: 'Email',
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            submitAttempted: submitAttempted,
          ),
          const SizedBox(height: AppDimensions.gapSm),
          AppTextField(
            key: const ValueKey('password'),
            controller: passwordController,
            focusNode: passwordFocus,
            label: 'Password',
            hint: 'Enter your password',
            obscure: true,
            keyboardType: TextInputType.visiblePassword,
            validator: Validators.validatePassword,
            visibleSvgAsset: 'assets/icons/eye_open.svg',
            hiddenSvgAsset: 'assets/icons/eye_hidden.svg',
            submitAttempted: submitAttempted,
          ),
          const SizedBox(height: AppDimensions.gapXs),
          Align(
            alignment: Alignment.centerRight,
            child: AppLink(
              text: 'Forgot password?',
              color: theme.colorScheme.secondary,
              fontSize: 14,
              onTap: () {
                Navigator.pushNamed(
                    context, '/forgot-password');
              },
            ),
          ),
          const SizedBox(height: AppDimensions.gapSm),
          AppButton(
            label: 'Log in',
            onPressed: onSubmit,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
