import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/auth/signup/view_models/signup_viewmodel.dart';
import 'package:loop/ui/auth/signup/widgets/post_signup_screen.dart';
import 'package:loop/ui/shared/widgets/app_progress_bar.dart';
import 'package:loop/ui/auth/signup/widgets/signup_footer.dart';
import 'package:loop/ui/auth/signup/widgets/signup_step_field.dart';
import 'package:loop/ui/auth/signup/widgets/signup_top_bar.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/ui/shared/widgets/app_snack_bar.dart';
import 'package:loop/utils/validators.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  static const int totalSteps = 4;

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

  final Map<int, FocusNode> _focusMap = {};

  int _currentStep = 0;
  bool _submitAttempted = false;

  bool _hasMinLength = false;
  bool _hasNumber = false;
  bool _hasLowercase = false;
  String? _emailError;

  final List<String> _stepInstructions = [
    "Enter your email",
    "Create a password",
    "Confirm your password",
    "Choose a username",
  ];

  @override
  void initState() {
    super.initState();

    _focusMap.addAll({
      0: _emailFocus,
      1: _passwordFocus,
      2: _confirmFocus,
      3: _usernameFocus,
    });

    _passwordController
        .addListener(_updatePasswordRequirements);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestFocusForStep(0);
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

  void _requestFocusForStep(int step) {
    _focusMap[step]?.requestFocus();
  }

  bool _isStepValid() {
    switch (_currentStep) {
      case 0:
        return Validators.validateEmail(
                _emailController.text) ==
            null;
      case 1:
        return Validators.validatePassword(
                _passwordController.text) ==
            null;
      case 2:
        return Validators.validateConfirmPassword(
                _confirmController.text,
                _passwordController.text) ==
            null;
      case 3:
        return Validators.validateUsername(
                _usernameController.text) ==
            null;
      default:
        return false;
    }
  }

  void _validateAndContinue() async {
    setState(() => _submitAttempted = true);

    final isValid = _isStepValid();

    if (!isValid) {
      _keyboardListenerFocus.requestFocus();
      return;
    }

    if (_currentStep == 0) {
      final viewModel = context.read<SignUpViewModel>();
      final email = _emailController.text.trim();

      final isTaken = await viewModel.checkEmail(email);
      if (isTaken) {
        setState(() {
          _emailError =
              'Email already registered, please log in instead';
          _keyboardListenerFocus.requestFocus();
        });
        return;
      }
    }

    if (_currentStep < totalSteps - 1) {
      setState(() => _currentStep++);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _requestFocusForStep(_currentStep);
      });
    } else {
      _submit();
    }
  }

  void _submit() async {
    final viewModel = context.read<SignUpViewModel>();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final username = _usernameController.text.trim();

    final success =
        await viewModel.signup(email, password, username);

    if (!mounted) return;
    AppSnackBar.show(
      context,
      title:
          success ? 'Sign Up Successful' : 'Sign Up Failed',
      body: success ? '' : viewModel.errorMessage,
      type: success
          ? SnackBarType.success
          : SnackBarType.error,
    );

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PostSignupScreen(
            email: email,
          ),
        ),
      );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.read<SignUpViewModel>();

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
                maxWidth: AppDimensions.formWidth),
            child: Padding(
              padding:
                  const EdgeInsets.all(AppDimensions.gapMd),
              child: SizedBox(
                height: 400,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start,
                  children: [
                    Text(
                      'Create your account',
                      style: theme.textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                        height: AppDimensions.gapLg),
                    AppProgressBar(
                      currentStep: _currentStep,
                      totalSteps: totalSteps,
                    ),
                    const SizedBox(
                        height: AppDimensions.gapXs),
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
                        height: AppDimensions.gapSm),
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
                        hasLowercase: _hasLowercase,
                        emailError: _emailError,
                      ),
                    ),
                    const SizedBox(
                        height: AppDimensions.gapMd),
                    AppButton(
                      label: _currentStep < totalSteps - 1
                          ? 'Next'
                          : 'Sign Up',
                      onPressed: _validateAndContinue,
                      isLoading: viewModel.isLoading,
                    ),
                    if (_currentStep == 0) ...[
                      const SizedBox(
                          height: AppDimensions.gapLg),
                      const SignUpFooter(),
                    ],
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
