import 'package:flutter/material.dart';
import '../../services/preferences_service.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = PreferencesService.getSavedThemeMode();

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    PreferencesService.saveThemeMode(_themeMode);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      PreferencesService.saveThemeMode(_themeMode);
      notifyListeners();
    }
  }
}
