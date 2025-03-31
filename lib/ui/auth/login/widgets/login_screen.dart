import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/ui/auth/login/view_models/login_viewmodel.dart';
import 'package:loop/ui/shared/widgets/app_text_field.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearErrorOnInput);
    _passwordController.addListener(_clearErrorOnInput);
  }

  void _clearErrorOnInput() {
    final viewModel =
        Provider.of<LoginViewModel>(context, listen: false);
    viewModel.clearError();
  }

  void _login() async {
    final viewModel =
        Provider.of<LoginViewModel>(context, listen: false);
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final success =
          await viewModel.login(email, password);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Login Successful'
              : 'Login Failed'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                Text(
                  'Welcome back',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'Enter your email',
                          keyboardType:
                              TextInputType.emailAddress,
                          validator:
                              Validators.validateEmail,
                        ),
                        const SizedBox(height: 24.0),
                        AppTextField(
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
                        ),
                        const SizedBox(height: 24.0),
                        AppButton(
                          label: 'Log in',
                          onPressed: _login,
                          isLoading: viewModel.isLoading,
                        ),
                        if (viewModel.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 12.0),
                            child: Text(
                              viewModel.errorMessage!,
                              style: textTheme.bodyMedium
                                  ?.copyWith(
                                color: colorScheme.error,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.signup),
                      child: Text(
                        "Sign up",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
