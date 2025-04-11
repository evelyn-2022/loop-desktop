import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClearTokenButton extends StatelessWidget {
  const ClearTokenButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await SharedPreferences.getInstance()
            .then((prefs) => prefs.remove('access_token'));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Access token removed')),
        );
      },
      child: const Text('Clear Access Token'),
    );
  }
}
