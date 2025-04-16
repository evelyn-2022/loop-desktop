import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/auth/signup/widgets/progress_bar.dart';
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
  final _emailFieldKey =
      GlobalKey<FormFieldState<String>>();
  final _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  final _confirmFieldKey =
      GlobalKey<FormFieldState<String>>();
  final _usernameFieldKey =
      GlobalKey<FormFieldState<String>>();

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

  final List<String> _stepInstructions = [
    "Enter your email",
    "Create a password",
    "Confirm your password",
    "Choose a username",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
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

  Widget _buildTopBar() {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            setState(() {
              _currentStep--;
              _submitAttempted = false;
            });
            WidgetsBinding.instance
                .addPostFrameCallback((_) {
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
          },
        ),
        Text(
          _stepInstructions[_currentStep],
          style: theme.textTheme.titleMedium,
        ),
      ],
    );
  }

  Widget _buildStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return AppTextField(
          key: ValueKey('step-$_currentStep'),
          fieldKey: _emailFieldKey,
          controller: _emailController,
          focusNode: _emailFocus,
          label: 'Email',
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          validator: Validators.validateEmail,
          submitAttempted: _submitAttempted,
        );
      case 1:
        return AppTextField(
          key: ValueKey('step-$_currentStep'),
          fieldKey: _passwordFieldKey,
          focusNode: _passwordFocus,
          controller: _passwordController,
          label: 'Password',
          hint: 'Create a password',
          obscure: true,
          validator: Validators.validatePassword,
          keyboardType: TextInputType.visiblePassword,
          visibleSvgAsset: 'assets/icons/eye_open.svg',
          hiddenSvgAsset: 'assets/icons/eye_hidden.svg',
          submitAttempted: _submitAttempted,
        );
      case 2:
        return AppTextField(
          key: ValueKey('step-$_currentStep'),
          fieldKey: _confirmFieldKey,
          focusNode: _confirmFocus,
          controller: _confirmController,
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          obscure: true,
          validator: (_) => _confirmController.text !=
                  _passwordController.text
              ? "Passwords do not match"
              : null,
          keyboardType: TextInputType.visiblePassword,
          visibleSvgAsset: 'assets/icons/eye_open.svg',
          hiddenSvgAsset: 'assets/icons/eye_hidden.svg',
          submitAttempted: _submitAttempted,
        );
      case 3:
        return AppTextField(
          key: ValueKey('step-$_currentStep'),
          fieldKey: _usernameFieldKey,
          focusNode: _usernameFocus,
          controller: _usernameController,
          label: 'Username',
          hint: 'Choose a username',
          validator: (val) =>
              val == null || val.trim().isEmpty
                  ? "Username is required"
                  : null,
          keyboardType: TextInputType.text,
          submitAttempted: _submitAttempted,
        );
      default:
        return const SizedBox.shrink();
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
                  ProgressBar(
                    currentStep: _currentStep,
                    totalSteps: 4,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapSm),
                  _buildTopBar(),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  Form(
                    key: _formKey,
                    child: _buildStepContent(context),
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  AppButton(
                    label: _currentStep < 3
                        ? 'Next'
                        : 'Sign Up',
                    onPressed: _validateAndContinue,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  if (_currentStep == 0) ...[
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
