import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:hive_ce/hive.dart';
import '../core/database/secure_db.dart';
import '../models/helpline.dart';

class HelplineRepository {
  static const _boxName = 'helplines_box';

  Future<List<Helpline>> getHelplines() async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    if (box.isEmpty) {
      await _preloadDefaultHelplines(box);
    } else {
      await _migrateOldDefaultsIfNeeded(box);
    }

    final list = <Helpline>[];
    for (final key in box.keys) {
      final value = box.get(key);
      if (value != null) {
        try {
          list.add(Helpline.fromJson(jsonDecode(value)));
        } catch (_) {}
      }
    }
    return list;
  }

  Future<void> saveHelpline(Helpline helpline) async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    await box.put(helpline.id, jsonEncode(helpline.toJson()));
  }

  Future<void> deleteHelpline(String id) async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    await box.delete(id);
  }

  Future<void> resetHelplines() async {
    final box = await SecureDb.openEncryptedBox<String>(_boxName);
    await box.clear();
    await _preloadDefaultHelplines(box);
  }

  Future<void> _migrateOldDefaultsIfNeeded(Box<String> box) async {
    bool hasOldDefaults = false;
    for (final key in box.keys) {
      final val = box.get(key);
      if (val != null && (val.contains('1800116117') || val.contains('9820122602') || val.contains('1512'))) {
        hasOldDefaults = true;
        break;
      }
    }
    if (hasOldDefaults) {
      await box.clear();
      await _preloadDefaultHelplines(box);
    }
  }

  Future<void> _preloadDefaultHelplines(Box<String> box) async {
    const uuid = Uuid();
    final defaults = [
      Helpline(id: uuid.v4(), name: 'Police', number: '100', category: 'Security', isFavorite: true),
      Helpline(id: uuid.v4(), name: 'Fire', number: '101', category: 'Fire', isFavorite: true),
      Helpline(id: uuid.v4(), name: 'Ambulance', number: '102', category: 'Medical', isFavorite: true),
      Helpline(id: uuid.v4(), name: 'Traffic Police', number: '103', category: 'Security'),
      Helpline(id: uuid.v4(), name: 'State Level Helpline for Health', number: '104', category: 'Medical'),
      Helpline(id: uuid.v4(), name: 'Disaster Management / Medical Helpline', number: '108', category: 'Disaster', isFavorite: true),
      Helpline(id: uuid.v4(), name: 'All in One Emergency Number (General Emergency – Department of Telecommunications, DoT)', number: '112', category: 'General', isFavorite: true),
      Helpline(id: uuid.v4(), name: 'Indian Railway General Enquiry', number: '131', category: 'Transport'),
      Helpline(id: uuid.v4(), name: 'Railway Enquiry', number: '139', category: 'Transport'),
      Helpline(id: uuid.v4(), name: 'Domestic Abuse and Sexual Violence – Women\'s Helpline', number: '181', category: 'Safety'),
      Helpline(id: uuid.v4(), name: 'Directory Enquiry Service', number: '197', category: 'Directory'),
      Helpline(id: uuid.v4(), name: 'Telephone Complaint Booking', number: '198', category: 'Utility'),
      Helpline(id: uuid.v4(), name: 'Anti Corruption Helpline', number: '1031', category: 'Security'),
      Helpline(id: uuid.v4(), name: 'Emergency Relief Centre on National Highways', number: '1033', category: 'Transport'),
      Helpline(id: uuid.v4(), name: 'Anti-poison', number: '1066', category: 'Medical'),
      Helpline(id: uuid.v4(), name: 'Air Accident', number: '1071', category: 'Disaster'),
      Helpline(id: uuid.v4(), name: 'Train Accident', number: '1072', category: 'Disaster'),
      Helpline(id: uuid.v4(), name: 'Road Accident / Traffic Helpline', number: '1073', category: 'Transport'),
      Helpline(id: uuid.v4(), name: 'Anti Terror Helpline / Alert All India', number: '1090', category: 'Security'),
      Helpline(id: uuid.v4(), name: 'Women Helpline in Distress', number: '1091', category: 'Safety'),
      Helpline(id: uuid.v4(), name: 'Earthquake Helpline Service', number: '1092', category: 'Disaster'),
      Helpline(id: uuid.v4(), name: 'Natural Disaster Control Room', number: '1096', category: 'Disaster'),
      Helpline(id: uuid.v4(), name: 'AIDS Helpline', number: '1097', category: 'Medical'),
      Helpline(id: uuid.v4(), name: 'Child Abuse Hotline (Childline)', number: '1098', category: 'Safety'),
      Helpline(id: uuid.v4(), name: 'Central Accident and Trauma Services', number: '1099', category: 'Medical'),
      Helpline(id: uuid.v4(), name: 'Kisan Call Center', number: '1551', category: 'Agriculture'),
      Helpline(id: uuid.v4(), name: 'LPG Emergency Helpline Number', number: '1906', category: 'Utility'),
      Helpline(id: uuid.v4(), name: 'Blood Bank Information', number: '1910', category: 'Medical'),
      Helpline(id: uuid.v4(), name: 'Eye Donation / Eye Bank Information Service', number: '1919', category: 'Medical'),
      Helpline(id: uuid.v4(), name: 'Aadhaar Card / UIDAI (1800-180-1947)', number: '1947', category: 'Government'),
      Helpline(id: uuid.v4(), name: 'Election Commission of India', number: '1950', category: 'Government'),
      Helpline(id: uuid.v4(), name: 'National Consumer Helpline', number: '1800-11-4000', category: 'Consumer'),
    ];

    for (final helpline in defaults) {
      await box.put(helpline.id, jsonEncode(helpline.toJson()));
    }
  }
}
