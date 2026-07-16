// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'helpline.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Helpline _$HelplineFromJson(Map<String, dynamic> json) => _Helpline(
  id: json['id'] as String,
  name: json['name'] as String,
  number: json['number'] as String,
  category: json['category'] as String,
  isFavorite: json['isFavorite'] as bool? ?? false,
  notes: json['notes'] as String? ?? '',
);

Map<String, dynamic> _$HelplineToJson(_Helpline instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'number': instance.number,
  'category': instance.category,
  'isFavorite': instance.isFavorite,
  'notes': instance.notes,
};
