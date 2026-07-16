import 'dart:convert';
import '../core/database/secure_db.dart';
import '../models/medical_profile.dart';

class MedicalRepository {
  static const _boxName = 'medical_box';
  static const _key = 'medical_profile';

  Future<MedicalProfile> getMedicalProfile() async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    final data = box.get(_key);
    if (data == null) {
      return const MedicalProfile();
    }
    try {
      return MedicalProfile.fromJson(jsonDecode(data));
    } catch (_) {
      return const MedicalProfile();
    }
  }

  Future<void> saveMedicalProfile(MedicalProfile profile) async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    await box.put(_key, jsonEncode(profile.toJson()));
  }
}
