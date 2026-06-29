import 'package:flutter/material.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Maps known client-side error/success messages to their localized
/// equivalents. Server-originating messages pass through unchanged.
String translateAuthMessage(BuildContext context, String message) {
  final l10n = AppLocalizations.of(context)!;

  // Map of English fallback keys → localized getters.
  // Only client-side messages that are NOT from the backend appear here.
  final msg = message.toLowerCase().trim();

  // Exact client-side mappings
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
  }

  // Server error matchings
  if (msg.contains('username and password') || msg.contains('invalid credentials') || msg.contains('username or password')) {
    return l10n.error_invalid_credentials;
  }
  
  if (msg.contains('username is required')) return l10n.err_username_required;
  if (msg.contains('username must be between 3 and 30 characters')) return l10n.err_username_length;
  if (msg.contains('username can only contain letters, numbers, underscores, and dots')) return l10n.err_username_chars;
  if (msg.contains('password is required')) return l10n.err_password_required;
  if (msg.contains('password must be at least 8 characters long')) return l10n.err_password_length;
  if (msg.contains('password must not exceed 128 characters')) return l10n.err_password_max_length;
  if (msg.contains('password must contain at least one uppercase letter')) return l10n.err_password_upper;
  if (msg.contains('password must contain at least one lowercase letter')) return l10n.err_password_lower;
  if (msg.contains('password must contain at least one digit')) return l10n.err_password_digit;
  if (msg.contains('phone number must be 8-15 digits')) return l10n.err_phone_format;
  if (msg.contains('address must not exceed 200 characters')) return l10n.err_address_length;
  if (msg.contains('already in use') && msg.contains('username')) return l10n.err_username_in_use;
  
  if (msg.contains('order items are required')) return l10n.err_order_items_required;
  if (msg.contains('order not found')) return l10n.err_order_not_found;
  if (msg.contains('cannot cancel order in') || msg.contains('cannot cancel order. it is already')) return l10n.err_order_cannot_cancel;
  if (msg.contains('only cancel your own orders')) return l10n.err_order_cancel_own;
  if (msg.contains('user not found')) return l10n.err_user_not_found;
  if (msg.contains('invalid token') || msg.contains('token expired') || msg.contains('invalid refresh token')) return l10n.err_invalid_token;
  if (msg.contains('already in use')) return l10n.err_already_in_use;
  if (msg.contains('no valid fields to update')) return l10n.err_no_valid_fields;
  if (msg.contains('minimum order amount is')) return msg.replaceFirst('minimum order amount is ', l10n.err_min_amount_prefix);
  
  if (msg.contains('product not found')) return l10n.err_product_not_found;
  if (msg.contains('category not found')) return l10n.err_category_not_found;
  if (msg.contains('brand not found')) return l10n.err_brand_not_found;

  if (msg.contains('product') && (msg.contains('not available') || msg.contains('unavailable'))) {
    return l10n.error_product_unavailable;
  }
  
  if (msg.contains('server error') || msg.contains('something went wrong')) {
    return l10n.error_generic;
  }

  return message; // fallback
}
