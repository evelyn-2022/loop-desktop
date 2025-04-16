import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/shared/widgets/app_progress_bar.dart';
import 'package:loop/ui/auth/signup/widgets/signup_footer.dart';
import 'package:loop/ui/auth/signup/widgets/signup_step_field.dart';
import 'package:loop/ui/auth/signup/widgets/signup_top_bar.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _usernameController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();
  final _usernameFocus = FocusNode();

  final _keyboardListenerFocus = FocusNode();

  int _currentStep = 0;
  bool _submitAttempted = false;

  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasLowercase = false;

  final List<String> _stepInstructions = [
    "Enter your email",
    "Create a password",
    "Confirm your password",
    "Choose a username",
  ];

  @override
  void initState() {
    super.initState();

    _passwordController
        .addListener(_updatePasswordRequirements);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
  }

  void _updatePasswordRequirements() {
    final text = _passwordController.text;

    setState(() {
      _hasMinLength = text.length >= 8;
      _hasNumber = RegExp(r'\d').hasMatch(text);
      _hasLowercase = RegExp(r'[a-z]').hasMatch(text);
    });
  }

  void _validateAndContinue() {
    bool isValid = false;

    setState(() {
      _submitAttempted = true;
    });

    switch (_currentStep) {
      case 0:
        isValid = Validators.validateEmail(
                _emailController.text) ==
            null;
        break;
      case 1:
        isValid = Validators.validatePassword(
                _passwordController.text) ==
            null;
        break;
      case 2:
        isValid = _confirmController.text ==
            _passwordController.text;
        break;
      case 3:
        isValid =
            _usernameController.text.trim().isNotEmpty;
        break;
    }

    if (!isValid) {
      _keyboardListenerFocus.requestFocus();
      return;
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        switch (_currentStep) {
          case 0:
            _emailFocus.requestFocus();
            break;
          case 1:
            _passwordFocus.requestFocus();
            break;
          case 2:
            _confirmFocus.requestFocus();
            break;
          case 3:
            _usernameFocus.requestFocus();
            break;
        }
      });
    } else {
      _submit();
    }
  }

  @override
  void dispose() {
    _passwordController
        .removeListener(_updatePasswordRequirements);
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _usernameController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    _usernameFocus.dispose();
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  void _submit() {
    print("✅ Sign Up Info:");
    print("Email: ${_emailController.text}");
    print("Password: ${_passwordController.text}");
    print("Username: ${_usernameController.text}");
  }

  void _requestFocusForStep(int step) {
    switch (step) {
      case 0:
        _emailFocus.requestFocus();
        break;
      case 1:
        _passwordFocus.requestFocus();
        break;
      case 2:
        _confirmFocus.requestFocus();
        break;
      case 3:
        _usernameFocus.requestFocus();
        break;
    }
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
            _validateAndContinue();
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
                  AppProgressBar(
                    currentStep: _currentStep,
                    totalSteps: 4,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapSm),
                  SignUpTopBar(
                    currentStep: _currentStep,
                    stepInstructions: _stepInstructions,
                    onBack: () {
                      setState(() {
                        _currentStep--;
                        _submitAttempted = false;
                      });
                      _requestFocusForStep(_currentStep);
                    },
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  Form(
                      key: _formKey,
                      child: SignUpStepField(
                          step: _currentStep,
                          submitAttempted: _submitAttempted,
                          emailController: _emailController,
                          passwordController:
                              _passwordController,
                          confirmController:
                              _confirmController,
                          usernameController:
                              _usernameController,
                          emailFocus: _emailFocus,
                          passwordFocus: _passwordFocus,
                          confirmFocus: _confirmFocus,
                          usernameFocus: _usernameFocus,
                          hasMinLength: _hasMinLength,
                          hasNumber: _hasNumber,
                          hasLowercase: _hasLowercase)),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  AppButton(
                    label: _currentStep < 3
                        ? 'Next'
                        : 'Sign Up',
                    onPressed: _validateAndContinue,
                  ),
                  if (_currentStep == 0) ...[
                    const SizedBox(
                        height: AppDimensions.gapMd),
                    const SignUpFooter(),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
