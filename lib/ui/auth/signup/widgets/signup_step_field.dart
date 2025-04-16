import 'package:flutter/material.dart';
import 'package:loop/ui/shared/widgets/app_password_requirements.dart';
import 'package:loop/ui/shared/widgets/app_text_field.dart';
import 'package:loop/utils/validators.dart';

class SignUpStepField extends StatelessWidget {
  final int step;
  final bool submitAttempted;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmController;
  final TextEditingController usernameController;
  final FocusNode emailFocus;
  final FocusNode passwordFocus;
  final FocusNode confirmFocus;
  final FocusNode usernameFocus;
  final bool hasMinLength;
  final bool hasNumber;
  final bool hasLowercase;

  const SignUpStepField({
    super.key,
    required this.step,
    required this.submitAttempted,
    required this.emailController,
    required this.passwordController,
    required this.confirmController,
    required this.usernameController,
    required this.emailFocus,
    required this.passwordFocus,
    required this.confirmFocus,
    required this.usernameFocus,
    required this.hasMinLength,
    required this.hasNumber,
    required this.hasLowercase,
  });

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 0:
        return AppTextField(
          key: ValueKey('step-$step'),
          controller: emailController,
          focusNode: emailFocus,
          label: 'Email',
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
          submitAttempted: submitAttempted,
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              key: ValueKey('step-$step'),
              focusNode: passwordFocus,
              controller: passwordController,
              label: 'Password',
              hint: 'Create a password',
              obscure: true,
              validator: Validators.validatePassword,
              keyboardType: TextInputType.visiblePassword,
              visibleSvgAsset: 'assets/icons/eye_open.svg',
              hiddenSvgAsset: 'assets/icons/eye_hidden.svg',
              submitAttempted: submitAttempted,
            ),
            const SizedBox(height: 12),
            AppPasswordRequirements(
              hasMinLength: hasMinLength,
              hasNumber: hasNumber,
              hasLowercase: hasLowercase,
            ),
          ],
        );

      case 2:
        return AppTextField(
          key: ValueKey('step-$step'),
          controller: confirmController,
          focusNode: confirmFocus,
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          obscure: true,
          validator: (_) => confirmController.text !=
                  passwordController.text
              ? "Passwords do not match"
              : null,
          keyboardType: TextInputType.visiblePassword,
          visibleSvgAsset: 'assets/icons/eye_open.svg',
          hiddenSvgAsset: 'assets/icons/eye_hidden.svg',
          submitAttempted: submitAttempted,
        );
      case 3:
        return AppTextField(
          key: ValueKey('step-$step'),
          controller: usernameController,
          focusNode: usernameFocus,
          label: 'Username',
          hint: 'Choose a username',
          validator: (val) =>
              val == null || val.trim().isEmpty
                  ? "Username is required"
                  : null,
          keyboardType: TextInputType.text,
          submitAttempted: submitAttempted,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
