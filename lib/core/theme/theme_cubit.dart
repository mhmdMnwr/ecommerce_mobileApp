import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/injection_container.dart';

/// Cubit-like [ChangeNotifier] that manages the current [ThemeMode].
///
/// Persists the user's preference in [SharedPreferences].
class ThemeCubit extends ChangeNotifier {
  ThemeCubit() {
    _loadTheme();
  }

  static const String _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadTheme() async {
    final prefs = sl<SharedPreferences>();
    final stored = prefs.getString(_themeKey);
    if (stored != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == stored,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = sl<SharedPreferences>();
    await prefs.setString(_themeKey, mode.name);
  }

  Future<void> toggleTheme() async {
    final newMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(newMode);
  }
}
