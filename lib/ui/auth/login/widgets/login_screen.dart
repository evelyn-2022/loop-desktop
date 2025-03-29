import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loop/routes/routes.dart';
import 'package:loop/ui/auth/login/view_models/login_viewmodel.dart';
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
      appBar: AppBar(
        title:
            Text('Login', style: textTheme.headlineMedium),
        backgroundColor: colorScheme.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: viewModel.isLoading
            ? const Center(
                child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                        children: <Widget>[
                          TextFormField(
                            controller: _emailController,
                            decoration:
                                const InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType:
                                TextInputType.emailAddress,
                            validator:
                                Validators.validateEmail,
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(
                              labelText: 'Password',
                              hintText:
                                  'Enter your password',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            validator:
                                Validators.validatePassword,
                          ),
                          const SizedBox(height: 24.0),
                          ElevatedButton(
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets
                                  .symmetric(
                                  vertical: 16.0),
                              backgroundColor:
                                  colorScheme.primary,
                              foregroundColor:
                                  colorScheme.onPrimary,
                            ),
                            child: const Text('Login'),
                          ),
                          if (viewModel.errorMessage !=
                              null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(
                                      top: 12.0),
                              child: Text(
                                viewModel.errorMessage!,
                                style: textTheme.bodyMedium
                                    ?.copyWith(
                                        color: colorScheme
                                            .error),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text("No account? ",
                          style: textTheme.bodyMedium),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.signup);
                        },
                        child: Text(
                          "Sign up",
                          style: textTheme.bodyMedium
                              ?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
      ),
    );
  }
}
