import 'package:freezed_annotation/freezed_annotation.dart';

part 'medical_profile.freezed.dart';
part 'medical_profile.g.dart';

@freezed
abstract class MedicalProfile with _$MedicalProfile {
  const factory MedicalProfile({
    @Default('') String bloodGroup,
    @Default('') String rhFactor,
    @Default([]) List<String> allergies,
    @Default([]) List<String> foodAllergies,
    @Default([]) List<String> medicineAllergies,
    @Default([]) List<String> medicalConditions,
    @Default([]) List<String> currentMedicines,
    @Default([]) List<String> disabilities,
    @Default(false) bool organDonor,
    @Default('') String bloodPressure,
    @Default(false) bool diabetes,
    @Default(false) bool asthma,
    @Default(false) bool heartDisease,
    @Default(false) bool kidneyDisease,
    @Default(false) bool cancer,
    @Default(false) bool epilepsy,
    @Default(false) bool pregnancy,
    @Default('') String vision,
    @Default('') String hearing,
    @Default('') String mentalHealthNotes,
    @Default('') String healthNotes,
    @Default('') String doctorName,
    @Default('') String doctorPhone,
    @Default('') String hospitalName,
    @Default('') String hospitalPhone,
    @Default('') String insuranceProvider,
    @Default('') String insurancePolicyNumber,
    @Default('') String emergencyNotes,
  }) = _MedicalProfile;

  factory MedicalProfile.fromJson(Map<String, dynamic> json) =>
      _$MedicalProfileFromJson(json);
}
