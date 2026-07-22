import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
abstract class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('system') String themeMode,
    @Default(true) bool useDynamicColor,
    @Default(false) bool biometricEnabled,
    @Default('') String pinCode,
    @Default(5) int sosCountdownSeconds,
    @Default(true) bool persistentNotificationEnabled,
    @Default(true) bool showOnLockScreen,
    @Default("HELP ME!! IT'S AN EMERGENCY!!\n\nPlease reach ASAP to the location below") String sosSmsMessageTemplate,
    @Default(false) bool isSetupCompleted,
    @Default(true) bool autoFlashlightOnSos,
    @Default(true) bool autoAlarmOnSos,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);
}
