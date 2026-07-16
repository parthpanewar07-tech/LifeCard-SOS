import 'dart:convert';
import '../core/database/secure_db.dart';
import '../models/user_profile.dart';

class ProfileRepository {
  static const _boxName = 'profile_box';
  static const _key = 'user_profile';

  Future<UserProfile> getProfile() async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    final data = box.get(_key);
    if (data == null) {
      return const UserProfile();
    }
    try {
      return UserProfile.fromJson(jsonDecode(data));
    } catch (_) {
      return const UserProfile();
    }
  }

  Future<void> saveProfile(UserProfile profile) async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    await box.put(_key, jsonEncode(profile.toJson()));
  }
}
