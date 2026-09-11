import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../features/news/models/news_enums.dart';
import '../features/news/models/news_item.dart';

class PreferencesService {
  static const String _keyThemeMode = 'app_theme_mode';
  static const String _keyLanguage = 'app_language';
  static const String _keyBookmarks = 'app_saved_bookmarks';

  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get saved ThemeMode, defaults to ThemeMode.dark
  static ThemeMode getSavedThemeMode() {
    final themeStr = _prefs?.getString(_keyThemeMode);
    if (themeStr == 'light') return ThemeMode.light;
    if (themeStr == 'dark') return ThemeMode.dark;
    if (themeStr == 'system') return ThemeMode.system;
    return ThemeMode.dark;
  }

  /// Save selected ThemeMode
  static Future<void> saveThemeMode(ThemeMode mode) async {
    await _prefs?.setString(_keyThemeMode, mode.name);
  }

  /// Get saved NewsLanguage, defaults to NewsLanguage.english
  static NewsLanguage getSavedLanguage() {
    final langStr = _prefs?.getString(_keyLanguage);
    if (langStr != null) {
      for (final lang in NewsLanguage.values) {
        if (lang.name == langStr || lang.code == langStr) {
          return lang;
        }
      }
    }
    return NewsLanguage.english;
  }

  /// Save selected NewsLanguage
  static Future<void> saveLanguage(NewsLanguage language) async {
    await _prefs?.setString(_keyLanguage, language.name);
  }

  /// Get saved bookmarked items
  static List<NewsItem> getSavedBookmarks() {
    final list = _prefs?.getStringList(_keyBookmarks);
    if (list == null || list.isEmpty) return [];
    final items = <NewsItem>[];
    for (final str in list) {
      try {
        final map = jsonDecode(str) as Map<String, dynamic>;
        items.add(NewsItem.fromJson(map));
      } catch (_) {}
    }
    return items;
  }

  /// Save bookmarked items
  static Future<void> saveBookmarks(List<NewsItem> items) async {
    final list = items.map((e) => jsonEncode(e.toJson())).toList();
    await _prefs?.setStringList(_keyBookmarks, list);
  }
}
