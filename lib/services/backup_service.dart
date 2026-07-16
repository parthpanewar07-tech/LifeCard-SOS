import 'dart:convert';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import '../core/security/encryption_helper.dart';
import '../models/app_settings.dart';
import '../models/user_profile.dart';
import '../models/medical_profile.dart';
import '../models/emergency_contact.dart';
import '../models/helpline.dart';
import '../repositories/settings_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/medical_repository.dart';
import '../repositories/contact_repository.dart';
import '../repositories/helpline_repository.dart';

class BackupService {
  final SettingsRepository _settingsRepo;
  final ProfileRepository _profileRepo;
  final MedicalRepository _medicalRepo;
  final ContactRepository _contactRepo;
  final HelplineRepository _helplineRepo;

  BackupService({
    SettingsRepository? settingsRepo,
    ProfileRepository? profileRepo,
    MedicalRepository? medicalRepo,
    ContactRepository? contactRepo,
    HelplineRepository? helplineRepo,
  })  : _settingsRepo = settingsRepo ?? SettingsRepository(),
        _profileRepo = profileRepo ?? ProfileRepository(),
        _medicalRepo = medicalRepo ?? MedicalRepository(),
        _contactRepo = contactRepo ?? ContactRepository(),
        _helplineRepo = helplineRepo ?? HelplineRepository();

  /// Exports all database data as an encrypted ZIP archive to a temporary file.
  Future<File> exportBackup(String password) async {
    // 1. Gather all data
    final settings = await _settingsRepo.getSettings();
    final profile = await _profileRepo.getProfile();
    final medical = await _medicalRepo.getMedicalProfile();
    final contacts = await _contactRepo.getContacts();
    final helplines = await _helplineRepo.getHelplines();

    final dataMap = {
      'version': '1.0.0',
      'settings': settings.toJson(),
      'profile': profile.toJson(),
      'medical': medical.toJson(),
      'contacts': contacts.map((c) => c.toJson()).toList(),
      'helplines': helplines.map((h) => h.toJson()).toList(),
      'timestamp': DateTime.now().toIso8601String(),
    };

    // 2. Encrypt the JSON data string
    final jsonStr = jsonEncode(dataMap);
    final encryptedData = EncryptionHelper.encrypt(jsonStr, password);

    // 3. Create zip file
    final tempDir = await getTemporaryDirectory();
    final backupFile = File('${tempDir.path}/lifecard_backup_temp.json');
    await backupFile.writeAsString(encryptedData);

    final archive = Archive();
    final fileBytes = await backupFile.readAsBytes();
    archive.addFile(ArchiveFile('backup.enc', fileBytes.length, fileBytes));

    final zipEncoder = ZipEncoder();
    final zipBytes = zipEncoder.encode(archive);

    final zipFile = File('${tempDir.path}/lifecard_sos_backup.zip');
    await zipFile.writeAsBytes(zipBytes);

    // Cleanup temp JSON file
    if (await backupFile.exists()) {
      await backupFile.delete();
    }

    return zipFile;
  }

  /// Restores database data from an encrypted ZIP archive.
  Future<bool> restoreBackup(String zipFilePath, String password) async {
    try {
      final bytes = await File(zipFilePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      final backupEncFile = archive.findFile('backup.enc');

      if (backupEncFile == null) {
        return false;
      }

      final encryptedData = utf8.decode(backupEncFile.content as List<int>);
      final jsonStr = EncryptionHelper.decrypt(encryptedData, password);
      final dataMap = jsonDecode(jsonStr) as Map<String, dynamic>;

      // Verify versions / validity
      if (!dataMap.containsKey('settings') || !dataMap.containsKey('profile')) {
        return false;
      }

      // 4. Save models back to local storage
      final settings = AppSettings.fromJson(dataMap['settings'] as Map<String, dynamic>);
      final profile = UserProfile.fromJson(dataMap['profile'] as Map<String, dynamic>);
      final medical = MedicalProfile.fromJson(dataMap['medical'] as Map<String, dynamic>);

      final contactsJson = dataMap['contacts'] as List<dynamic>;
      final contacts = contactsJson.map((c) => EmergencyContact.fromJson(c as Map<String, dynamic>)).toList();

      final helplinesJson = dataMap['helplines'] as List<dynamic>;
      final helplines = helplinesJson.map((h) => Helpline.fromJson(h as Map<String, dynamic>)).toList();

      await _settingsRepo.saveSettings(settings);
      await _profileRepo.saveProfile(profile);
      await _medicalRepo.saveMedicalProfile(medical);
      await _contactRepo.saveAllContacts(contacts);

      // Clean up and restore helplines
      final helplineRepo = HelplineRepository();
      for (final helpline in helplines) {
        await helplineRepo.saveHelpline(helpline);
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}
