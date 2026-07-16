// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MedicalProfile _$MedicalProfileFromJson(Map<String, dynamic> json) =>
    _MedicalProfile(
      bloodGroup: json['bloodGroup'] as String? ?? '',
      rhFactor: json['rhFactor'] as String? ?? '',
      allergies:
          (json['allergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      foodAllergies:
          (json['foodAllergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      medicineAllergies:
          (json['medicineAllergies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      medicalConditions:
          (json['medicalConditions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      currentMedicines:
          (json['currentMedicines'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      disabilities:
          (json['disabilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      organDonor: json['organDonor'] as bool? ?? false,
      bloodPressure: json['bloodPressure'] as String? ?? '',
      diabetes: json['diabetes'] as bool? ?? false,
      asthma: json['asthma'] as bool? ?? false,
      heartDisease: json['heartDisease'] as bool? ?? false,
      kidneyDisease: json['kidneyDisease'] as bool? ?? false,
      cancer: json['cancer'] as bool? ?? false,
      epilepsy: json['epilepsy'] as bool? ?? false,
      pregnancy: json['pregnancy'] as bool? ?? false,
      vision: json['vision'] as String? ?? '',
      hearing: json['hearing'] as String? ?? '',
      mentalHealthNotes: json['mentalHealthNotes'] as String? ?? '',
      healthNotes: json['healthNotes'] as String? ?? '',
      doctorName: json['doctorName'] as String? ?? '',
      doctorPhone: json['doctorPhone'] as String? ?? '',
      hospitalName: json['hospitalName'] as String? ?? '',
      hospitalPhone: json['hospitalPhone'] as String? ?? '',
      insuranceProvider: json['insuranceProvider'] as String? ?? '',
      insurancePolicyNumber: json['insurancePolicyNumber'] as String? ?? '',
      emergencyNotes: json['emergencyNotes'] as String? ?? '',
    );

Map<String, dynamic> _$MedicalProfileToJson(_MedicalProfile instance) =>
    <String, dynamic>{
      'bloodGroup': instance.bloodGroup,
      'rhFactor': instance.rhFactor,
      'allergies': instance.allergies,
      'foodAllergies': instance.foodAllergies,
      'medicineAllergies': instance.medicineAllergies,
      'medicalConditions': instance.medicalConditions,
      'currentMedicines': instance.currentMedicines,
      'disabilities': instance.disabilities,
      'organDonor': instance.organDonor,
      'bloodPressure': instance.bloodPressure,
      'diabetes': instance.diabetes,
      'asthma': instance.asthma,
      'heartDisease': instance.heartDisease,
      'kidneyDisease': instance.kidneyDisease,
      'cancer': instance.cancer,
      'epilepsy': instance.epilepsy,
      'pregnancy': instance.pregnancy,
      'vision': instance.vision,
      'hearing': instance.hearing,
      'mentalHealthNotes': instance.mentalHealthNotes,
      'healthNotes': instance.healthNotes,
      'doctorName': instance.doctorName,
      'doctorPhone': instance.doctorPhone,
      'hospitalName': instance.hospitalName,
      'hospitalPhone': instance.hospitalPhone,
      'insuranceProvider': instance.insuranceProvider,
      'insurancePolicyNumber': instance.insurancePolicyNumber,
      'emergencyNotes': instance.emergencyNotes,
    };
