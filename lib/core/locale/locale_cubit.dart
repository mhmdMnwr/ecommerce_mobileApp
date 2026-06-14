import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/injection_container.dart';

/// Manages the current app locale and persists the choice.
class LocaleCubit extends ChangeNotifier {
  LocaleCubit() {
    _load();
  }

  static const String _key = 'app_locale';

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  static const supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];

  static const localeLabels = {
    'en': 'English',
    'fr': 'Français',
    'ar': 'العربية',
  };

  Future<void> _load() async {
    final prefs = sl<SharedPreferences>();
    final code = prefs.getString(_key);
    if (code != null) {
      _locale = Locale(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = sl<SharedPreferences>();
    await prefs.setString(_key, locale.languageCode);
  }
}
