/// Application-wide constants.
abstract class AppConstants {
  /// Base URL for the API (Supports --dart-define=API_URL=...)
  /// Use 'http://10.0.2.2:4000' for local dev on Android Emulator
  /// Use 'http://localhost:4000' for local dev on iOS/Web
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    // defaultValue: 'https://api-mnwr-ecommerce-backend.onrender.com',
    defaultValue: 'http://10.152.15.110:4000',
  );

  /// SharedPreferences keys.
  static const String localeKey = 'app_locale';
  static const String themeKey = 'theme_mode';
  static const String onboardingCompleteKey = 'onboarding_complete';
}
