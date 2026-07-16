import 'package:freezed_annotation/freezed_annotation.dart';

part 'emergency_contact.freezed.dart';
part 'emergency_contact.g.dart';

@freezed
abstract class EmergencyContact with _$EmergencyContact {
  const factory EmergencyContact({
    required String id,
    @Default('') String photoPath,
    @Default('') String name,
    @Default('') String relationship,
    @Default('') String primaryPhone,
    @Default('') String alternativePhone,
    @Default('') String email,
    @Default('') String address,
    @Default(0) int priority,
    @Default(false) bool isFavorite,
    @Default('') String notes,
    @Default(true) bool sendSmsOnSos,
  }) = _EmergencyContact;

  factory EmergencyContact.fromJson(Map<String, dynamic> json) =>
      _$EmergencyContactFromJson(json);
}
