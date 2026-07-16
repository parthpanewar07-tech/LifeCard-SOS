// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EmergencyContact _$EmergencyContactFromJson(Map<String, dynamic> json) =>
    _EmergencyContact(
      id: json['id'] as String,
      photoPath: json['photoPath'] as String? ?? '',
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      primaryPhone: json['primaryPhone'] as String? ?? '',
      alternativePhone: json['alternativePhone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      notes: json['notes'] as String? ?? '',
      sendSmsOnSos: json['sendSmsOnSos'] as bool? ?? true,
    );

Map<String, dynamic> _$EmergencyContactToJson(_EmergencyContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'photoPath': instance.photoPath,
      'name': instance.name,
      'relationship': instance.relationship,
      'primaryPhone': instance.primaryPhone,
      'alternativePhone': instance.alternativePhone,
      'email': instance.email,
      'address': instance.address,
      'priority': instance.priority,
      'isFavorite': instance.isFavorite,
      'notes': instance.notes,
      'sendSmsOnSos': instance.sendSmsOnSos,
    };
