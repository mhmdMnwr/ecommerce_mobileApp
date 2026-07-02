import 'package:flutter/foundation.dart';

/// Application-wide constants.
abstract class AppConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://localhost:4000',
  );

  /// SharedPreferences keys.
  static const String localeKey = 'app_locale';
  static const String themeKey = 'theme_mode';
  static const String onboardingCompleteKey = 'onboarding_complete';
}
