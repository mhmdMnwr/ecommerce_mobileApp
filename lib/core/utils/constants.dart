/// Application-wide constants.
abstract class AppConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.50.100.110:4000',
  );

  /// SharedPreferences keys.
  static const String localeKey = 'app_locale';
  static const String themeKey = 'theme_mode';
  static const String onboardingCompleteKey = 'onboarding_complete';
}
