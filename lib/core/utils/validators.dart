import 'package:flutter/material.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Reusable form-field validators.
abstract class Validators {
  /// Username must be non-empty and at least 3 characters.
  static String? username(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.usernameRequired;
    }
    if (value.trim().length < 3) {
      return AppLocalizations.of(context)!.usernameMinLength;
    }
    return null;
  }

  /// Password must be non-empty and at least 6 characters.
  static String? password(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordMinLength;
    }
    return null;
  }

  /// Phone must start with 05, 06, or 07 followed by 8 digits (10 total).
  static String? phone(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.phoneRequired;
    }
    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');
    if (!RegExp(r'^0[567]\d{8}$').hasMatch(cleaned)) {
      return AppLocalizations.of(context)!.phoneInvalid;
    }
    return null;
  }

  /// Address must be non-empty.
  static String? address(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.addressRequired;
    }
    return null;
  }
}
