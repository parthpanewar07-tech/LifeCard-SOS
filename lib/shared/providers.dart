import 'package:flutter_riverpod/flutter_riverpod.dart';
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

/// Centralized Riverpod Dependency Injection & Reactive Notifier Layer
/// Manages reactive application state and encrypted local persistence (Hive CE).

// Repository Providers
final settingsRepositoryProvider = Provider((ref) => SettingsRepository());
final profileRepositoryProvider = Provider((ref) => ProfileRepository());
final medicalRepositoryProvider = Provider((ref) => MedicalRepository());
final contactRepositoryProvider = Provider((ref) => ContactRepository());
final helplineRepositoryProvider = Provider((ref) => HelplineRepository());

/// Initial navigation location (can be overridden during cold launch from widgets or app shortcuts)
final initialLocationProvider = Provider<String>((ref) => '/');

// Settings Notifier
class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    return ref.read(settingsRepositoryProvider).getSettings();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(settingsRepositoryProvider).saveSettings(newSettings);
      state = AsyncValue.data(newSettings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> completeSetup() async {
    final current = state.value ?? const AppSettings();
    final updated = current.copyWith(isSetupCompleted: true);
    await updateSettings(updated);
  }
}

final settingsProvider = AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  () => SettingsNotifier(),
);

// Profile Notifier
class ProfileNotifier extends AsyncNotifier<UserProfile> {
  @override
  Future<UserProfile> build() async {
    return ref.read(profileRepositoryProvider).getProfile();
  }

  Future<void> updateProfile(UserProfile newProfile) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(profileRepositoryProvider).saveProfile(newProfile);
      state = AsyncValue.data(newProfile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, UserProfile>(
  () => ProfileNotifier(),
);

// Medical Profile Notifier
class MedicalProfileNotifier extends AsyncNotifier<MedicalProfile> {
  @override
  Future<MedicalProfile> build() async {
    return ref.read(medicalRepositoryProvider).getMedicalProfile();
  }

  Future<void> updateMedicalProfile(MedicalProfile newProfile) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(medicalRepositoryProvider).saveMedicalProfile(newProfile);
      state = AsyncValue.data(newProfile);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final medicalProfileProvider = AsyncNotifierProvider<MedicalProfileNotifier, MedicalProfile>(
  () => MedicalProfileNotifier(),
);

// Emergency Contacts Notifier
class ContactsNotifier extends AsyncNotifier<List<EmergencyContact>> {
  @override
  Future<List<EmergencyContact>> build() async {
    return ref.read(contactRepositoryProvider).getContacts();
  }

  Future<void> addContact(EmergencyContact contact) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(contactRepositoryProvider);
      await repo.saveContact(contact);
      final currentList = await repo.getContacts();
      state = AsyncValue.data(currentList);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteContact(String id) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(contactRepositoryProvider);
      await repo.deleteContact(id);
      final currentList = await repo.getContacts();
      state = AsyncValue.data(currentList);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> reorderContacts(List<EmergencyContact> updatedList) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(contactRepositoryProvider);
      await repo.saveAllContacts(updatedList);
      final currentList = await repo.getContacts();
      state = AsyncValue.data(currentList);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final contactsProvider = AsyncNotifierProvider<ContactsNotifier, List<EmergencyContact>>(
  () => ContactsNotifier(),
);

// Helplines Notifier
class HelplinesNotifier extends AsyncNotifier<List<Helpline>> {
  @override
  Future<List<Helpline>> build() async {
    return ref.read(helplineRepositoryProvider).getHelplines();
  }

  Future<void> addHelpline(Helpline helpline) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(helplineRepositoryProvider);
      await repo.saveHelpline(helpline);
      final currentList = await repo.getHelplines();
      state = AsyncValue.data(currentList);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteHelpline(String id) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(helplineRepositoryProvider);
      await repo.deleteHelpline(id);
      final currentList = await repo.getHelplines();
      state = AsyncValue.data(currentList);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> resetToDefaults() async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(helplineRepositoryProvider);
      await repo.resetHelplines();
      final currentList = await repo.getHelplines();
      state = AsyncValue.data(currentList);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final helplinesProvider = AsyncNotifierProvider<HelplinesNotifier, List<Helpline>>(
  () => HelplinesNotifier(),
);
