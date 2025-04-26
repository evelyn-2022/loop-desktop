import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop/ui/auth/oauth/widgets/social_login.dart';
import 'package:loop/theme/app_dimensions.dart';
import 'package:loop/ui/auth/login/widgets/login_footer.dart';
import 'package:loop/ui/auth/login/widgets/login_form.dart';
import 'package:loop/ui/shared/widgets/app_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:loop/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _keyboardListenerFocus = FocusNode();

  bool _submitAttempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() => _submitAttempted = true);
    final viewModel = context.read<LoginViewModel>();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final isFormValid =
        Validators.validateEmail(email) == null &&
            Validators.validatePassword(password) == null;

    if (!isFormValid || viewModel.isLoading) {
      _keyboardListenerFocus.requestFocus();
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: Focus(
        focusNode: _keyboardListenerFocus,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
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
                    'Welcome back',
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapLg),
                  LoginForm(
                    formKey: _formKey,
                    emailController: _emailController,
                    passwordController: _passwordController,
                    emailFocus: _emailFocus,
                    passwordFocus: _passwordFocus,
                    submitAttempted: _submitAttempted,
                    onSubmit: _login,
                    isLoading: viewModel.isLoading,
                  ),
                  const SizedBox(
                      height: AppDimensions.gapLg),
                  const SocialLogin(),
                  const SizedBox(
                      height: AppDimensions.gapLg),
                  const LoginFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  KeyEventResult _handleKeyEvent(
      FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent)
      return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
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

    return KeyEventResult.ignored;
  }
}
