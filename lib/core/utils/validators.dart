/// Reusable form-field validators.
abstract class Validators {
  /// Username must be non-empty and at least 3 characters.
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  /// Password must be non-empty and at least 6 characters.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Phone must start with 05, 06, or 07 followed by 8 digits (10 total).
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^0[567]\d{8}$').hasMatch(cleaned)) {
      return 'Phone must start with 05, 06, or 07 (10 digits)';
    }
    return null;
  }

  /// Address must be non-empty.
  static String? address(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    return null;
  }
}
