import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';
import 'package:loop/ui/shared/widgets/app_text_field.dart';
import 'package:loop/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _emailController = TextEditingController();
  final _keyboardListenerFocus = FocusNode();

  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
  }

  void _validateAndShowErrors() {
    final error =
        Validators.validateEmail(_emailController.text) ==
            null;

    setState(() {
      _isFormValid = error;
    });

    if (!_isFormValid) {
      // Save current focus
      final hasFocus = _emailFocus.hasFocus;

      // Remove focus temporarily
      _keyboardListenerFocus.requestFocus();

      // Schedule to restore focus after the frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (hasFocus) {
          _emailFocus.requestFocus();
        }
      });
    }
  }

  void _goToNextStep() {
    _validateAndShowErrors();
    if (_isFormValid) {
      // TODO: Go to next step (e.g., setState to switch UI or navigate)
      print("Email: ${_emailController.text}");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Focus(
        focusNode: _keyboardListenerFocus,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey ==
                  LogicalKeyboardKey.enter) {
            _goToNextStep();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppDimensions.formWidth,
            ),
            child: Padding(
              padding:
                  const EdgeInsets.all(AppDimensions.gapMd),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Create your account',
                    style: theme.textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  Form(
                    key: _formKey,
                    child: AppTextField(
                      focusNode: _emailFocus,
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType:
                          TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  AppButton(
                    label: 'Next',
                    onPressed: _goToNextStep,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ",
                          style:
                              theme.textTheme.bodyMedium),
                      AppLink(
                        text: "Log in",
                        onTap: () => Navigator.pushNamed(
                            context, '/login'),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  AppLink(
                    text: "Continue as guest",
                    fontSize: 14,
                    color: theme.colorScheme.secondary,
                    onTap: () =>
                        Navigator.pushReplacementNamed(
                            context, '/home'),
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
