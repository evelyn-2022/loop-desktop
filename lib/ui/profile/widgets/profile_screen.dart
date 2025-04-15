import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:loop/data/repositories/auth_repository.dart';
import 'package:loop/data/services/models/api_response.dart';
import 'package:loop/providers/auth_state.dart';
import 'package:loop/ui/profile/view_models/profile_viewmodel.dart';
import 'package:loop/ui/shared/widgets/app_button.dart';
import 'package:loop/ui/shared/widgets/app_snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  final bool shouldLoad;
  const ProfileScreen(
      {super.key, required this.shouldLoad});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _hasLoaded = false;

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.shouldLoad && !_hasLoaded) {
      _hasLoaded = true;
      Future.microtask(() {
        if (!mounted) return;
        context.read<ProfileViewModel>().loadProfile();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final profileViewModel =
        context.watch<ProfileViewModel>();

    final user = profileViewModel.user;
    final isLoading = profileViewModel.isLoading;
    final error = profileViewModel.error;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Profile', style: textTheme.headlineMedium),
          const SizedBox(height: 24),
          CircleAvatar(
            radius: 40,
            backgroundColor:
                colorScheme.primary.withOpacity(0.1),
            child: Icon(Icons.person,
                size: 40, color: colorScheme.primary),
          ),
          const SizedBox(height: 16),
          if (isLoading) ...[
            const CircularProgressIndicator(),
          ] else if (error != null) ...[
            Text('Error: $error',
                style: textTheme.bodyMedium),
          ] else if (user != null) ...[
            Text('Username: ${user.username}',
                style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Email: ${user.email}',
                style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            AppButton(
              label: "Logout",
              onPressed: () async {
                final authRepository =
                    context.read<AuthRepository>();
                final authState = context.read<AuthState>();

                final result =
                    await authRepository.logout();

                if (!context.mounted) return;

                if (result is ApiSuccess) {
                  authState.clear();

                  Navigator.pushReplacementNamed(
                      context, '/home');
                  AppSnackBar.show(
                    context,
                    title: "Logged out",
                    type: SnackBarType.success,
                  );
                } else if (result is ApiError) {
                  AppSnackBar.show(
                    context,
                    title: "Logout failed",
                    body: result.message,
                    type: SnackBarType.error,
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}
