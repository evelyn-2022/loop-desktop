import 'package:flutter/material.dart';
import 'package:loop/ui/profile/view_models/profile_viewmodel.dart';

import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProfileViewModel>().loadProfile();
    });
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
          ],
        ],
      ),
    );
  }
}
