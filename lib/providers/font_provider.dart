import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider with ChangeNotifier {
  double _fontSize = 16.0;
  static const String _fontSizeKey = 'font_size';

  FontProvider() {
    // Load saved font size when provider is created
    _loadSavedFontSize();
  }

  double get fontSize => _fontSize;

  // Load the saved font size from SharedPreferences
  Future<void> _loadSavedFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFontSize = prefs.getDouble(_fontSizeKey);

    if (savedFontSize != null) {
      _fontSize = savedFontSize;
      notifyListeners();
    }
  }

  // Save font size to SharedPreferences
  Future<void> _saveFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  Future<void> setFontSize(double size) async {
    if (size >= 12 && size <= 24) {
      _fontSize = size;
      await _saveFontSize(size);
      notifyListeners();
    }
  }
}
