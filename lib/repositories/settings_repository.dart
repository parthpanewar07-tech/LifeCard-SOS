import 'dart:convert';
import '../core/database/secure_db.dart';
import '../models/app_settings.dart';

class SettingsRepository {
  static const _boxName = 'settings_box';
  static const _key = 'app_settings';

  Future<AppSettings> getSettings() async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    final data = box.get(_key);
    if (data == null) {
      return const AppSettings();
    }
    try {
      var settings = AppSettings.fromJson(jsonDecode(data));
      // Migrate old default SMS template to the new one
      if (settings.sosSmsMessageTemplate.contains(
        "HELP ME!! IT'S AN EMERGENCY!!\n\nPlease reach ASAP to the location below",
      )) {
        settings = settings.copyWith(
          sosSmsMessageTemplate:
              "HELP ME!! IT'S AN EMERGENCY!!\n\nPlease reach ASAP to the location below",
        );
        await saveSettings(settings);
      }
      return settings;
    } catch (_) {
      return const AppSettings();
    }
  }

  Future<void> saveSettings(AppSettings settings) async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    await box.put(_key, jsonEncode(settings.toJson()));
  }
}
