import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    // Start loading preferences immediately, but don't block
    _loadThemeFromPrefs();
  }

  // Initialize theme - can be awaited
  Future<void> initializeTheme() async {
    await _loadThemeFromPrefs();
  }

  // Load theme preference from storage
  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      notifyListeners();
    } catch (e) {
      // Default to light theme on error
      _isDarkMode = false;
    }
  }

  // Toggle theme and save preference
  Future<void> toggleTheme(bool value) async {
    if (_isDarkMode == value) return; // No change

    _isDarkMode = value;
    notifyListeners(); // Notify immediately for responsive UI

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', value);
    } catch (e) {
      return;
    }
  }

  // Get current theme
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
}
