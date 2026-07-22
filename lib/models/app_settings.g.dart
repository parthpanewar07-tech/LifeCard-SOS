// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => _AppSettings(
  themeMode: json['themeMode'] as String? ?? 'system',
  useDynamicColor: json['useDynamicColor'] as bool? ?? true,
  biometricEnabled: json['biometricEnabled'] as bool? ?? false,
  pinCode: json['pinCode'] as String? ?? '',
  sosCountdownSeconds: (json['sosCountdownSeconds'] as num?)?.toInt() ?? 5,
  persistentNotificationEnabled:
      json['persistentNotificationEnabled'] as bool? ?? true,
  showOnLockScreen: json['showOnLockScreen'] as bool? ?? true,
  sosSmsMessageTemplate:
      json['sosSmsMessageTemplate'] as String? ??
      "HELP ME!! IT'S AN EMERGENCY!!\n\nPlease reach ASAP to the location below",
  isSetupCompleted: json['isSetupCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$AppSettingsToJson(_AppSettings instance) =>
    <String, dynamic>{
      'themeMode': instance.themeMode,
      'useDynamicColor': instance.useDynamicColor,
      'biometricEnabled': instance.biometricEnabled,
      'pinCode': instance.pinCode,
      'sosCountdownSeconds': instance.sosCountdownSeconds,
      'persistentNotificationEnabled': instance.persistentNotificationEnabled,
      'showOnLockScreen': instance.showOnLockScreen,
      'sosSmsMessageTemplate': instance.sosSmsMessageTemplate,
      'isSetupCompleted': instance.isSetupCompleted,
    };
