import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
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
      horizontalOffset: AppDimensions.navBarWidth,
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome back',
                  style: theme.textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.gapMd),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      AppTextField(
                        fieldKey: _emailFieldKey,
                        controller: _emailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType:
                            TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(
                          height: AppDimensions.gapSm),
                      AppTextField(
                        fieldKey: _passwordFieldKey,
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
                const SizedBox(height: AppDimensions.gapMd),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      "New here? ",
                      style: theme.textTheme.bodyMedium,
                    ),
                    GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, AppRoutes.signup),
                        child: AppLink(
                          text: "Create an account",
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.signup),
                        )),
                  ],
                ),
                const SizedBox(height: AppDimensions.gapMd),
                GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.home),
                    child: AppLink(
                      text: "Continue as guest",
                      color: Theme.of(context)
                          .colorScheme
                          .secondary,
                      fontSize: 14,
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.home),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
