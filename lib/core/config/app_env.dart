import 'package:flutter/services.dart' show rootBundle;

class AppEnv {
  AppEnv._();

  static final Map<String, String> _envMap = {};

  static String get newsApiBaseUrl => _envMap['NEWS_API_BASE_URL'] ?? '';
  static String get newsApiKey => _envMap['NEWS_API_KEY'] ?? '';
  static String get englishRssBaseUrl => _envMap['ENGLISH_RSS_BASE_URL'] ?? '';
  static String get hindiRssBaseUrl => _envMap['HINDI_RSS_BASE_URL'] ?? '';
  static String get gujaratiRssBaseUrl => _envMap['GUJARATI_RSS_BASE_URL'] ?? '';
  static int get apiTimeoutSeconds => int.tryParse(_envMap['API_TIMEOUT_SECONDS'] ?? '') ?? 15;

  /// Loads and parses the `.env` asset file into memory
  static Future<void> load() async {
    try {
      final content = await rootBundle.loadString('.env');
      for (final line in content.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final parts = trimmed.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final val = parts.sublist(1).join('=').trim();
          _envMap[key] = val;
        }
      }
    } catch (_) {
      // Fallback defaults retain values if .env file fails to load
    }
  }
}
