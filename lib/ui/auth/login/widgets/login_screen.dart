import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/shared/widgets/app_link.dart';
import 'package:loop/ui/shared/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:loop/ui/shared/widgets/app_text_field.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _emailFieldKey =
      GlobalKey<FormFieldState<String>>();
  final _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  bool _isFormValid = false;
  bool _submitAttempted = false;

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _keyboardListenerFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });

    _emailController.addListener(() {
      _clearErrorOnInput();
      _updateFormValidState();
    });
    _passwordController.addListener(() {
      _clearErrorOnInput();
      _updateFormValidState();
    });
  }

  void _updateFormValidState() {
    final emailValid =
        Validators.validateEmail(_emailController.text) ==
            null;
    final passwordValid = Validators.validatePassword(
            _passwordController.text) ==
        null;

    setState(() {
      _isFormValid = emailValid && passwordValid;
    });
  }

  void _clearErrorOnInput() {
    final viewModel =
        Provider.of<LoginViewModel>(context, listen: false);
    viewModel.clearError();
  }

  void _login() async {
    final viewModel =
        Provider.of<LoginViewModel>(context, listen: false);
    _submitAttempted = true;
    _validateAndShowErrors();

    if (!_isFormValid || viewModel.isLoading) {
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;
    final success = await viewModel.login(email, password);

    AppSnackBar.show(
      context,
      title: success ? 'Login Successful' : 'Login Failed',
      body: success ? '' : viewModel.errorMessage,
      type: success
          ? SnackBarType.success
          : SnackBarType.error,
    );

    if (success) {
      Navigator.pushReplacementNamed(
          context, AppRoutes.home);
    }
  }

  void _validateAndShowErrors() {
    // First check if the form is valid
    final emailValid =
        Validators.validateEmail(_emailController.text) ==
            null;
    final passwordValid = Validators.validatePassword(
            _passwordController.text) ==
        null;

    setState(() {
      _isFormValid = emailValid && passwordValid;
    });

    if (!_isFormValid) {
      // Save current focus
      final hasFocus = _passwordFocus.hasFocus;

      // Remove focus temporarily
      _keyboardListenerFocus.requestFocus();

      // Schedule to restore focus after the frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (hasFocus) {
          _passwordFocus.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Focus(
        focusNode: _keyboardListenerFocus,
        autofocus: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey ==
                LogicalKeyboardKey.arrowDown) {
              _passwordFocus.requestFocus();
              return KeyEventResult.handled;
            } else if (event.logicalKey ==
                LogicalKeyboardKey.arrowUp) {
              _emailFocus.requestFocus();
              return KeyEventResult.handled;
            } else if (event.logicalKey ==
                LogicalKeyboardKey.enter) {
              if (_emailFocus.hasFocus) {
                _passwordFocus.requestFocus();
              } else if (_passwordFocus.hasFocus) {
                _login();
              }
              return KeyEventResult.handled;
            }
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
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  Text(
                    'Welcome back',
                    style: theme.textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AppTextField(
                          fieldKey: _emailFieldKey,
                          focusNode: _emailFocus,
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Enter your email',
                          keyboardType:
                              TextInputType.emailAddress,
                          validator:
                              Validators.validateEmail,
                          submitAttempted: _submitAttempted,
                        ),
                        const SizedBox(
                            height: AppDimensions.gapSm),
                        AppTextField(
                          fieldKey: _passwordFieldKey,
                          focusNode: _passwordFocus,
                          controller: _passwordController,
                          label: 'Password',
                          hint: 'Enter your password',
                          obscure: true,
                          keyboardType:
                              TextInputType.visiblePassword,
                          validator:
                              Validators.validatePassword,
                          visibleSvgAsset:
                              'assets/icons/eye_open.svg',
                          hiddenSvgAsset:
                              'assets/icons/eye_hidden.svg',
                          submitAttempted: _submitAttempted,
                        ),
                        const SizedBox(
                            height: AppDimensions.gapSm),
                        AppButton(
                          label: 'Log in',
                          onPressed: _login,
                          isLoading: viewModel.isLoading,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        "New here? ",
                        style: theme.textTheme.bodyMedium,
                      ),
                      AppLink(
                        text: "Create an account",
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.signup),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  AppLink(
                    text: "Continue as guest",
                    color: Theme.of(context)
                        .colorScheme
                        .secondary,
                    fontSize: 14,
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.home),
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
