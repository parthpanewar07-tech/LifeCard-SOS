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

  Future<void> _preloadDefaultHelplines(Box<String> box) async {
    const uuid = Uuid();
    final defaults = [
      Helpline(id: uuid.v4(), name: 'National Emergency Number', number: '112', category: 'General', isFavorite: true),
      Helpline(id: uuid.v4(), name: 'Police', number: '100', category: 'Security', isFavorite: true),
      Helpline(id: uuid.v4(), name: 'Fire', number: '101', category: 'Fire', isFavorite: true),
      Helpline(id: uuid.v4(), name: 'Ambulance', number: '102', category: 'Medical', isFavorite: true),
      Helpline(id: uuid.v4(), name: 'Women Helpline', number: '1091', category: 'Safety'),
      Helpline(id: uuid.v4(), name: 'Child Helpline', number: '1098', category: 'Safety'),
      Helpline(id: uuid.v4(), name: 'Disaster Management', number: '108', category: 'Disaster'),
      Helpline(id: uuid.v4(), name: 'Poison Control', number: '1800116117', category: 'Medical'),
      Helpline(id: uuid.v4(), name: 'Railway Inquiry / Security', number: '1512', category: 'Transport'),
      Helpline(id: uuid.v4(), name: 'Cyber Crime Helpline', number: '1930', category: 'Security'),
      Helpline(id: uuid.v4(), name: 'Gas Leakage Helpline', number: '1906', category: 'Utility'),
      Helpline(id: uuid.v4(), name: 'Road Accident Emergency', number: '1073', category: 'Transport'),
      Helpline(id: uuid.v4(), name: 'Animal Rescue (PETA)', number: '9820122602', category: 'Animal'),
    ];

    for (final helpline in defaults) {
      await box.put(helpline.id, jsonEncode(helpline.toJson()));
    }
  }
}
