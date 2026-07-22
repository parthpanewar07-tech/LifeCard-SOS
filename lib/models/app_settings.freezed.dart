// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppSettings {

 String get themeMode; bool get useDynamicColor; bool get biometricEnabled; String get pinCode; int get sosCountdownSeconds; bool get persistentNotificationEnabled; bool get showOnLockScreen; String get sosSmsMessageTemplate; bool get isSetupCompleted; bool get autoFlashlightOnSos; bool get autoAlarmOnSos;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);

  /// Serializes this AppSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.useDynamicColor, useDynamicColor) || other.useDynamicColor == useDynamicColor)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.pinCode, pinCode) || other.pinCode == pinCode)&&(identical(other.sosCountdownSeconds, sosCountdownSeconds) || other.sosCountdownSeconds == sosCountdownSeconds)&&(identical(other.persistentNotificationEnabled, persistentNotificationEnabled) || other.persistentNotificationEnabled == persistentNotificationEnabled)&&(identical(other.showOnLockScreen, showOnLockScreen) || other.showOnLockScreen == showOnLockScreen)&&(identical(other.sosSmsMessageTemplate, sosSmsMessageTemplate) || other.sosSmsMessageTemplate == sosSmsMessageTemplate)&&(identical(other.isSetupCompleted, isSetupCompleted) || other.isSetupCompleted == isSetupCompleted)&&(identical(other.autoFlashlightOnSos, autoFlashlightOnSos) || other.autoFlashlightOnSos == autoFlashlightOnSos)&&(identical(other.autoAlarmOnSos, autoAlarmOnSos) || other.autoAlarmOnSos == autoAlarmOnSos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,useDynamicColor,biometricEnabled,pinCode,sosCountdownSeconds,persistentNotificationEnabled,showOnLockScreen,sosSmsMessageTemplate,isSetupCompleted,autoFlashlightOnSos,autoAlarmOnSos);

@override
String toString() {
  return 'AppSettings(themeMode: $themeMode, useDynamicColor: $useDynamicColor, biometricEnabled: $biometricEnabled, pinCode: $pinCode, sosCountdownSeconds: $sosCountdownSeconds, persistentNotificationEnabled: $persistentNotificationEnabled, showOnLockScreen: $showOnLockScreen, sosSmsMessageTemplate: $sosSmsMessageTemplate, isSetupCompleted: $isSetupCompleted, autoFlashlightOnSos: $autoFlashlightOnSos, autoAlarmOnSos: $autoAlarmOnSos)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 String themeMode, bool useDynamicColor, bool biometricEnabled, String pinCode, int sosCountdownSeconds, bool persistentNotificationEnabled, bool showOnLockScreen, String sosSmsMessageTemplate, bool isSetupCompleted, bool autoFlashlightOnSos, bool autoAlarmOnSos
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? useDynamicColor = null,Object? biometricEnabled = null,Object? pinCode = null,Object? sosCountdownSeconds = null,Object? persistentNotificationEnabled = null,Object? showOnLockScreen = null,Object? sosSmsMessageTemplate = null,Object? isSetupCompleted = null,Object? autoFlashlightOnSos = null,Object? autoAlarmOnSos = null,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,useDynamicColor: null == useDynamicColor ? _self.useDynamicColor : useDynamicColor // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,pinCode: null == pinCode ? _self.pinCode : pinCode // ignore: cast_nullable_to_non_nullable
as String,sosCountdownSeconds: null == sosCountdownSeconds ? _self.sosCountdownSeconds : sosCountdownSeconds // ignore: cast_nullable_to_non_nullable
as int,persistentNotificationEnabled: null == persistentNotificationEnabled ? _self.persistentNotificationEnabled : persistentNotificationEnabled // ignore: cast_nullable_to_non_nullable
as bool,showOnLockScreen: null == showOnLockScreen ? _self.showOnLockScreen : showOnLockScreen // ignore: cast_nullable_to_non_nullable
as bool,sosSmsMessageTemplate: null == sosSmsMessageTemplate ? _self.sosSmsMessageTemplate : sosSmsMessageTemplate // ignore: cast_nullable_to_non_nullable
as String,isSetupCompleted: null == isSetupCompleted ? _self.isSetupCompleted : isSetupCompleted // ignore: cast_nullable_to_non_nullable
as bool,autoFlashlightOnSos: null == autoFlashlightOnSos ? _self.autoFlashlightOnSos : autoFlashlightOnSos // ignore: cast_nullable_to_non_nullable
as bool,autoAlarmOnSos: null == autoAlarmOnSos ? _self.autoAlarmOnSos : autoAlarmOnSos // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String themeMode,  bool useDynamicColor,  bool biometricEnabled,  String pinCode,  int sosCountdownSeconds,  bool persistentNotificationEnabled,  bool showOnLockScreen,  String sosSmsMessageTemplate,  bool isSetupCompleted,  bool autoFlashlightOnSos,  bool autoAlarmOnSos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.useDynamicColor,_that.biometricEnabled,_that.pinCode,_that.sosCountdownSeconds,_that.persistentNotificationEnabled,_that.showOnLockScreen,_that.sosSmsMessageTemplate,_that.isSetupCompleted,_that.autoFlashlightOnSos,_that.autoAlarmOnSos);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String themeMode,  bool useDynamicColor,  bool biometricEnabled,  String pinCode,  int sosCountdownSeconds,  bool persistentNotificationEnabled,  bool showOnLockScreen,  String sosSmsMessageTemplate,  bool isSetupCompleted,  bool autoFlashlightOnSos,  bool autoAlarmOnSos)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.themeMode,_that.useDynamicColor,_that.biometricEnabled,_that.pinCode,_that.sosCountdownSeconds,_that.persistentNotificationEnabled,_that.showOnLockScreen,_that.sosSmsMessageTemplate,_that.isSetupCompleted,_that.autoFlashlightOnSos,_that.autoAlarmOnSos);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String themeMode,  bool useDynamicColor,  bool biometricEnabled,  String pinCode,  int sosCountdownSeconds,  bool persistentNotificationEnabled,  bool showOnLockScreen,  String sosSmsMessageTemplate,  bool isSetupCompleted,  bool autoFlashlightOnSos,  bool autoAlarmOnSos)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.themeMode,_that.useDynamicColor,_that.biometricEnabled,_that.pinCode,_that.sosCountdownSeconds,_that.persistentNotificationEnabled,_that.showOnLockScreen,_that.sosSmsMessageTemplate,_that.isSetupCompleted,_that.autoFlashlightOnSos,_that.autoAlarmOnSos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppSettings implements AppSettings {
  const _AppSettings({this.themeMode = 'system', this.useDynamicColor = true, this.biometricEnabled = false, this.pinCode = '', this.sosCountdownSeconds = 5, this.persistentNotificationEnabled = true, this.showOnLockScreen = true, this.sosSmsMessageTemplate = "HELP ME!! IT'S AN EMERGENCY!!\n\nPlease reach ASAP to the location below", this.isSetupCompleted = false, this.autoFlashlightOnSos = true, this.autoAlarmOnSos = true});
  factory _AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);

@override@JsonKey() final  String themeMode;
@override@JsonKey() final  bool useDynamicColor;
@override@JsonKey() final  bool biometricEnabled;
@override@JsonKey() final  String pinCode;
@override@JsonKey() final  int sosCountdownSeconds;
@override@JsonKey() final  bool persistentNotificationEnabled;
@override@JsonKey() final  bool showOnLockScreen;
@override@JsonKey() final  String sosSmsMessageTemplate;
@override@JsonKey() final  bool isSetupCompleted;
@override@JsonKey() final  bool autoFlashlightOnSos;
@override@JsonKey() final  bool autoAlarmOnSos;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.useDynamicColor, useDynamicColor) || other.useDynamicColor == useDynamicColor)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.pinCode, pinCode) || other.pinCode == pinCode)&&(identical(other.sosCountdownSeconds, sosCountdownSeconds) || other.sosCountdownSeconds == sosCountdownSeconds)&&(identical(other.persistentNotificationEnabled, persistentNotificationEnabled) || other.persistentNotificationEnabled == persistentNotificationEnabled)&&(identical(other.showOnLockScreen, showOnLockScreen) || other.showOnLockScreen == showOnLockScreen)&&(identical(other.sosSmsMessageTemplate, sosSmsMessageTemplate) || other.sosSmsMessageTemplate == sosSmsMessageTemplate)&&(identical(other.isSetupCompleted, isSetupCompleted) || other.isSetupCompleted == isSetupCompleted)&&(identical(other.autoFlashlightOnSos, autoFlashlightOnSos) || other.autoFlashlightOnSos == autoFlashlightOnSos)&&(identical(other.autoAlarmOnSos, autoAlarmOnSos) || other.autoAlarmOnSos == autoAlarmOnSos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,themeMode,useDynamicColor,biometricEnabled,pinCode,sosCountdownSeconds,persistentNotificationEnabled,showOnLockScreen,sosSmsMessageTemplate,isSetupCompleted,autoFlashlightOnSos,autoAlarmOnSos);

@override
String toString() {
  return 'AppSettings(themeMode: $themeMode, useDynamicColor: $useDynamicColor, biometricEnabled: $biometricEnabled, pinCode: $pinCode, sosCountdownSeconds: $sosCountdownSeconds, persistentNotificationEnabled: $persistentNotificationEnabled, showOnLockScreen: $showOnLockScreen, sosSmsMessageTemplate: $sosSmsMessageTemplate, isSetupCompleted: $isSetupCompleted, autoFlashlightOnSos: $autoFlashlightOnSos, autoAlarmOnSos: $autoAlarmOnSos)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 String themeMode, bool useDynamicColor, bool biometricEnabled, String pinCode, int sosCountdownSeconds, bool persistentNotificationEnabled, bool showOnLockScreen, String sosSmsMessageTemplate, bool isSetupCompleted, bool autoFlashlightOnSos, bool autoAlarmOnSos
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? useDynamicColor = null,Object? biometricEnabled = null,Object? pinCode = null,Object? sosCountdownSeconds = null,Object? persistentNotificationEnabled = null,Object? showOnLockScreen = null,Object? sosSmsMessageTemplate = null,Object? isSetupCompleted = null,Object? autoFlashlightOnSos = null,Object? autoAlarmOnSos = null,}) {
  return _then(_AppSettings(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as String,useDynamicColor: null == useDynamicColor ? _self.useDynamicColor : useDynamicColor // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,pinCode: null == pinCode ? _self.pinCode : pinCode // ignore: cast_nullable_to_non_nullable
as String,sosCountdownSeconds: null == sosCountdownSeconds ? _self.sosCountdownSeconds : sosCountdownSeconds // ignore: cast_nullable_to_non_nullable
as int,persistentNotificationEnabled: null == persistentNotificationEnabled ? _self.persistentNotificationEnabled : persistentNotificationEnabled // ignore: cast_nullable_to_non_nullable
as bool,showOnLockScreen: null == showOnLockScreen ? _self.showOnLockScreen : showOnLockScreen // ignore: cast_nullable_to_non_nullable
as bool,sosSmsMessageTemplate: null == sosSmsMessageTemplate ? _self.sosSmsMessageTemplate : sosSmsMessageTemplate // ignore: cast_nullable_to_non_nullable
as String,isSetupCompleted: null == isSetupCompleted ? _self.isSetupCompleted : isSetupCompleted // ignore: cast_nullable_to_non_nullable
as bool,autoFlashlightOnSos: null == autoFlashlightOnSos ? _self.autoFlashlightOnSos : autoFlashlightOnSos // ignore: cast_nullable_to_non_nullable
as bool,autoAlarmOnSos: null == autoAlarmOnSos ? _self.autoAlarmOnSos : autoAlarmOnSos // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
