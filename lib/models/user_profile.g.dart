// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  photoPath: json['photoPath'] as String? ?? '',
  fullName: json['fullName'] as String? ?? '',
  nickname: json['nickname'] as String? ?? '',
  dateOfBirth: json['dateOfBirth'] == null
      ? null
      : DateTime.parse(json['dateOfBirth'] as String),
  gender: json['gender'] as String? ?? '',
  bloodGroup: json['bloodGroup'] as String? ?? '',
  height: (json['height'] as num?)?.toDouble() ?? 0.0,
  weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
  nationality: json['nationality'] as String? ?? '',
  address: json['address'] as String? ?? '',
  city: json['city'] as String? ?? '',
  district: json['district'] as String? ?? '',
  state: json['state'] as String? ?? '',
  country: json['country'] as String? ?? '',
  pinCode: json['pinCode'] as String? ?? '',
  occupation: json['occupation'] as String? ?? '',
  language: json['language'] as String? ?? 'en',
  aadhaar: json['aadhaar'] as String?,
  emergencyNotes: json['emergencyNotes'] as String? ?? '',
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'photoPath': instance.photoPath,
      'fullName': instance.fullName,
      'nickname': instance.nickname,
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'gender': instance.gender,
      'bloodGroup': instance.bloodGroup,
      'height': instance.height,
      'weight': instance.weight,
      'nationality': instance.nationality,
      'address': instance.address,
      'city': instance.city,
      'district': instance.district,
      'state': instance.state,
      'country': instance.country,
      'pinCode': instance.pinCode,
      'occupation': instance.occupation,
      'language': instance.language,
      'aadhaar': instance.aadhaar,
      'emergencyNotes': instance.emergencyNotes,
    };
