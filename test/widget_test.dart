import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_mint/services/preferences_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.init();
  });

  test('PreferencesService initial defaults test', () {
    expect(PreferencesService.getSavedLanguage().name, equals('english'));
    expect(PreferencesService.getSavedThemeMode().name, equals('dark'));
  });

  test('PreferencesService save and retrieve language and theme', () async {
    await PreferencesService.saveLanguage(PreferencesService.getSavedLanguage());
    await PreferencesService.saveThemeMode(PreferencesService.getSavedThemeMode());
    expect(PreferencesService.getSavedLanguage().name, equals('english'));
  });
}
