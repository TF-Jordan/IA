import 'package:flutter/material.dart';

import 'app_theme.dart';

/// Manages the active theme across the entire application.
///
/// Exposed via [ChangeNotifierProvider] at the root of the widget tree.
/// Any widget can read the current theme or switch it:
///
/// ```dart
/// // Read
/// final themeMode = context.watch<ThemeProvider>().themeMode;
///
/// // Switch
/// context.read<ThemeProvider>().setTheme(AppThemeMode.dark);
/// ```
class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode;

  ThemeProvider({AppThemeMode initialTheme = AppThemeMode.light})
      : _themeMode = initialTheme;

  AppThemeMode get themeMode => _themeMode;

  ThemeData get themeData => AppTheme.fromMode(_themeMode);

  void setTheme(AppThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void cycleTheme() {
    final values = AppThemeMode.values;
    final nextIndex = (_themeMode.index + 1) % values.length;
    setTheme(values[nextIndex]);
  }

  bool get isLight => _themeMode == AppThemeMode.light;
  bool get isDark => _themeMode == AppThemeMode.dark;
  bool get isOcean => _themeMode == AppThemeMode.ocean;

  /// Human-readable label for the current theme.
  String get label {
    switch (_themeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.ocean:
        return 'Ocean';
    }
  }

  /// Icon representing the current theme.
  IconData get icon {
    switch (_themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode_rounded;
      case AppThemeMode.dark:
        return Icons.dark_mode_rounded;
      case AppThemeMode.ocean:
        return Icons.water_rounded;
    }
  }
}
