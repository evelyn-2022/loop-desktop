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

  void _login() async {
    final viewModel = context.read<LoginViewModel>();
    setState(() => _submitAttempted = true);

    final emailValid =
        Validators.validateEmail(_emailController.text) ==
            null;
    final passwordValid = Validators.validatePassword(
            _passwordController.text) ==
        null;

    final isFormValid = emailValid && passwordValid;

    if (!isFormValid || viewModel.isLoading) {
      _keyboardListenerFocus.requestFocus();
      return;
    }

    final success = await viewModel.login(
      _emailController.text,
      _passwordController.text,
    );

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: Focus(
        focusNode: _keyboardListenerFocus,
        autofocus: true,
        onKeyEvent: _handleKeyEvent,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: AppDimensions.formWidth),
            child: Padding(
              padding:
                  const EdgeInsets.all(AppDimensions.gapMd),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Welcome back',
                      style: theme.textTheme.displayLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  _buildLoginForm(viewModel),
                  const SizedBox(
                      height: AppDimensions.gapMd),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(LoginViewModel viewModel) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            key: ValueKey('email'),
            controller: _emailController,
            focusNode: _emailFocus,
            label: 'Email',
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validator: Validators.validateEmail,
            submitAttempted: _submitAttempted,
          ),
          const SizedBox(height: AppDimensions.gapSm),
          AppTextField(
            key: ValueKey('password'),
            controller: _passwordController,
            focusNode: _passwordFocus,
            label: 'Password',
            hint: 'Enter your password',
            obscure: true,
            keyboardType: TextInputType.visiblePassword,
            validator: Validators.validatePassword,
            visibleSvgAsset: 'assets/icons/eye_open.svg',
            hiddenSvgAsset: 'assets/icons/eye_hidden.svg',
            submitAttempted: _submitAttempted,
          ),
          const SizedBox(height: AppDimensions.gapSm),
          AppButton(
            label: 'Log in',
            onPressed: _login,
            isLoading: viewModel.isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("New here? ",
                style: theme.textTheme.bodyMedium),
            AppLink(
              text: "Create an account",
              onTap: () => Navigator.pushNamed(
                  context, AppRoutes.signup),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.gapMd),
        AppLink(
          text: "Continue as guest",
          color: theme.colorScheme.secondary,
          fontSize: 14,
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.home),
        ),
      ],
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
