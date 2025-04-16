class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(
            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? confirm, String? original) {
    if (confirm == null || confirm.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirm != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a username';
    }

    final trimmed = value.trim();

    if (trimmed.length > 20) {
      return 'Username must be between 1 and 20 characters';
    }

    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(trimmed)) {
      return 'Only letters, numbers, and underscores allowed';
    }

    return null;
  }
}
