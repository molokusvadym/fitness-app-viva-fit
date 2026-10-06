import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsStorage {
  static const String _accentKey = "accentColor";
  static const String _fontScaleKey = "fontScale";
  static const String _fontFamilyKey = "fontFamily";
  static const String _colourBlindKey = "colourBlindMode";

  static Future<void> saveAccent(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentKey, color.value);
  }

  static Future<Color?> loadAccent() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getInt(_accentKey);
    if (value == null) return null;
    return Color(value);
  }

  static Future<void> saveFontScale(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontScaleKey, scale);
  }

  static Future<double?> loadFontScale() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontScaleKey);
  }

  static Future<void> saveFontFamily(String font) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontFamilyKey, font);
  }

  static Future<String?> loadFontFamily() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fontFamilyKey);
  }

  static Future<void> saveColourBlindMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_colourBlindKey, mode);
  }

  static Future<String?> loadColourBlindMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_colourBlindKey);
  }
}