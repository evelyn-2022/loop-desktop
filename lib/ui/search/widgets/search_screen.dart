import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Search', style: textTheme.headlineMedium),
          const SizedBox(height: 24),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search music, artists, albums...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Text(
                'Search results will appear here.',
                style: textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
