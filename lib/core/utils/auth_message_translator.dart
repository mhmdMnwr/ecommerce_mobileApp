import 'package:flutter/material.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Maps known client-side error/success messages to their localized
/// equivalents. Server-originating messages pass through unchanged.
String translateAuthMessage(BuildContext context, String message) {
  final l10n = AppLocalizations.of(context)!;

  // Map of English fallback keys → localized getters.
  // Only client-side messages that are NOT from the backend appear here.
  switch (message) {
    case 'Login failed. Please try again.':
      return l10n.loginFailed;
    case 'Registration failed. Please try again.':
      return l10n.registrationFailed;
    case 'Profile update failed.':
      return l10n.profileUpdateFailed;
    case 'Registration successful! Please log in.':
      return l10n.registrationSuccess;
    case 'Failed to load data.':
      return l10n.failedToLoadData;
    default:
      return message; // server message — show as-is
  }
}
