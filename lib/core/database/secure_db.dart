import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

class SecureDb {
  SecureDb._(); // Private constructor

  static const _storage = FlutterSecureStorage();
  static const _keyAlias = 'secure_db_key_aes256';

  static List<int>? _encryptionKey;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    final appDir = await getApplicationDocumentsDirectory();
    Hive.init(appDir.path);

    // Retrieve or generate the AES-256 key
    String? keyBase64 = await _storage.read(key: _keyAlias);
    if (keyBase64 == null) {
      final newKey = Hive.generateSecureKey();
      await _storage.write(key: _keyAlias, value: base64UrlEncode(newKey));
      _encryptionKey = newKey;
    } else {
      try {
        _encryptionKey = base64Url.decode(keyBase64);
      } catch (_) {
        // Fallback if decode fails, recreate key (safeguard)
        final newKey = Hive.generateSecureKey();
        await _storage.write(key: _keyAlias, value: base64UrlEncode(newKey));
        _encryptionKey = newKey;
      }
    }
    _initialized = true;
  }

  static Future<Box<T>> openEncryptedBox<T>(String name) async {
    if (!_initialized) {
      await init();
    }
    return await Hive.openBox<T>(
      name,
      encryptionCipher: HiveAesCipher(_encryptionKey!),
    );
  }

  /// Helper to wipe everything (for developer settings / database reset)
  static Future<void> wipeAllData() async {
    await Hive.close();
    await Hive.deleteFromDisk();
    await _storage.delete(key: _keyAlias);
    _initialized = false;
    _encryptionKey = null;
    await init();
  }
}
