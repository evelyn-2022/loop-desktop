import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
          Text('Username: johndoe',
              style: textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text('Email: johndoe@example.com',
              style: textTheme.bodyMedium),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Placeholder logout action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Logged out (placeholder)')),
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
