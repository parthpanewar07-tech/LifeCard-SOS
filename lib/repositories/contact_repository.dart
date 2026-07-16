import 'dart:convert';
import '../core/database/secure_db.dart';
import '../models/emergency_contact.dart';

class ContactRepository {
  static const _boxName = 'contacts_box';

  Future<List<EmergencyContact>> getContacts() async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    final list = <EmergencyContact>[];
    for (final key in box.keys) {
      final value = box.get(key);
      if (value != null) {
        try {
          list.add(EmergencyContact.fromJson(jsonDecode(value)));
        } catch (_) {}
      }
    }
    // Sort by priority (lower number = higher priority)
    list.sort((a, b) => a.priority.compareTo(b.priority));
    return list;
  }

  Future<void> saveContact(EmergencyContact contact) async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    await box.put(contact.id, jsonEncode(contact.toJson()));
  }

  Future<void> deleteContact(String id) async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    await box.delete(id);
  }

  Future<void> saveAllContacts(List<EmergencyContact> contacts) async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    // Clear and save to reset indexes/priorities properly
    await box.clear();
    for (int i = 0; i < contacts.length; i++) {
      final updated = contacts[i].copyWith(priority: i);
      await box.put(updated.id, jsonEncode(updated.toJson()));
    }
  }
}
