// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {

 String get photoPath; String get fullName; String get nickname; DateTime? get dateOfBirth; String get gender; String get bloodGroup; double get height; double get weight; String get nationality; String get address; String get city; String get district; String get state; String get country; String get pinCode; String get occupation; String? get aadhaar; String get emergencyNotes;
/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserProfileCopyWith<UserProfile> get copyWith => _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserProfile&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.pinCode, pinCode) || other.pinCode == pinCode)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.aadhaar, aadhaar) || other.aadhaar == aadhaar)&&(identical(other.emergencyNotes, emergencyNotes) || other.emergencyNotes == emergencyNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,photoPath,fullName,nickname,dateOfBirth,gender,bloodGroup,height,weight,nationality,address,city,district,state,country,pinCode,occupation,aadhaar,emergencyNotes);

@override
String toString() {
  return 'UserProfile(photoPath: $photoPath, fullName: $fullName, nickname: $nickname, dateOfBirth: $dateOfBirth, gender: $gender, bloodGroup: $bloodGroup, height: $height, weight: $weight, nationality: $nationality, address: $address, city: $city, district: $district, state: $state, country: $country, pinCode: $pinCode, occupation: $occupation, aadhaar: $aadhaar, emergencyNotes: $emergencyNotes)';
}


}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res>  {
  factory $UserProfileCopyWith(UserProfile value, $Res Function(UserProfile) _then) = _$UserProfileCopyWithImpl;
@useResult
$Res call({
 String photoPath, String fullName, String nickname, DateTime? dateOfBirth, String gender, String bloodGroup, double height, double weight, String nationality, String address, String city, String district, String state, String country, String pinCode, String occupation, String? aadhaar, String emergencyNotes
});




}
/// @nodoc
class _$UserProfileCopyWithImpl<$Res>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? photoPath = null,Object? fullName = null,Object? nickname = null,Object? dateOfBirth = freezed,Object? gender = null,Object? bloodGroup = null,Object? height = null,Object? weight = null,Object? nationality = null,Object? address = null,Object? city = null,Object? district = null,Object? state = null,Object? country = null,Object? pinCode = null,Object? occupation = null,Object? aadhaar = freezed,Object? emergencyNotes = null,}) {
  return _then(_self.copyWith(
photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,pinCode: null == pinCode ? _self.pinCode : pinCode // ignore: cast_nullable_to_non_nullable
as String,occupation: null == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String,aadhaar: freezed == aadhaar ? _self.aadhaar : aadhaar // ignore: cast_nullable_to_non_nullable
as String?,emergencyNotes: null == emergencyNotes ? _self.emergencyNotes : emergencyNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserProfile value)  $default,){
final _that = this;
switch (_that) {
case _UserProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserProfile value)?  $default,){
final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String photoPath,  String fullName,  String nickname,  DateTime? dateOfBirth,  String gender,  String bloodGroup,  double height,  double weight,  String nationality,  String address,  String city,  String district,  String state,  String country,  String pinCode,  String occupation,  String? aadhaar,  String emergencyNotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.photoPath,_that.fullName,_that.nickname,_that.dateOfBirth,_that.gender,_that.bloodGroup,_that.height,_that.weight,_that.nationality,_that.address,_that.city,_that.district,_that.state,_that.country,_that.pinCode,_that.occupation,_that.aadhaar,_that.emergencyNotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String photoPath,  String fullName,  String nickname,  DateTime? dateOfBirth,  String gender,  String bloodGroup,  double height,  double weight,  String nationality,  String address,  String city,  String district,  String state,  String country,  String pinCode,  String occupation,  String? aadhaar,  String emergencyNotes)  $default,) {final _that = this;
switch (_that) {
case _UserProfile():
return $default(_that.photoPath,_that.fullName,_that.nickname,_that.dateOfBirth,_that.gender,_that.bloodGroup,_that.height,_that.weight,_that.nationality,_that.address,_that.city,_that.district,_that.state,_that.country,_that.pinCode,_that.occupation,_that.aadhaar,_that.emergencyNotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String photoPath,  String fullName,  String nickname,  DateTime? dateOfBirth,  String gender,  String bloodGroup,  double height,  double weight,  String nationality,  String address,  String city,  String district,  String state,  String country,  String pinCode,  String occupation,  String? aadhaar,  String emergencyNotes)?  $default,) {final _that = this;
switch (_that) {
case _UserProfile() when $default != null:
return $default(_that.photoPath,_that.fullName,_that.nickname,_that.dateOfBirth,_that.gender,_that.bloodGroup,_that.height,_that.weight,_that.nationality,_that.address,_that.city,_that.district,_that.state,_that.country,_that.pinCode,_that.occupation,_that.aadhaar,_that.emergencyNotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserProfile implements UserProfile {
  const _UserProfile({this.photoPath = '', this.fullName = '', this.nickname = '', this.dateOfBirth, this.gender = '', this.bloodGroup = '', this.height = 0.0, this.weight = 0.0, this.nationality = '', this.address = '', this.city = '', this.district = '', this.state = '', this.country = '', this.pinCode = '', this.occupation = '', this.aadhaar, this.emergencyNotes = ''});
  factory _UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

@override@JsonKey() final  String photoPath;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  String nickname;
@override final  DateTime? dateOfBirth;
@override@JsonKey() final  String gender;
@override@JsonKey() final  String bloodGroup;
@override@JsonKey() final  double height;
@override@JsonKey() final  double weight;
@override@JsonKey() final  String nationality;
@override@JsonKey() final  String address;
@override@JsonKey() final  String city;
@override@JsonKey() final  String district;
@override@JsonKey() final  String state;
@override@JsonKey() final  String country;
@override@JsonKey() final  String pinCode;
@override@JsonKey() final  String occupation;
@override final  String? aadhaar;
@override@JsonKey() final  String emergencyNotes;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserProfileCopyWith<_UserProfile> get copyWith => __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserProfile&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.bloodGroup, bloodGroup) || other.bloodGroup == bloodGroup)&&(identical(other.height, height) || other.height == height)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.nationality, nationality) || other.nationality == nationality)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.district, district) || other.district == district)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.pinCode, pinCode) || other.pinCode == pinCode)&&(identical(other.occupation, occupation) || other.occupation == occupation)&&(identical(other.aadhaar, aadhaar) || other.aadhaar == aadhaar)&&(identical(other.emergencyNotes, emergencyNotes) || other.emergencyNotes == emergencyNotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,photoPath,fullName,nickname,dateOfBirth,gender,bloodGroup,height,weight,nationality,address,city,district,state,country,pinCode,occupation,aadhaar,emergencyNotes);

@override
String toString() {
  return 'UserProfile(photoPath: $photoPath, fullName: $fullName, nickname: $nickname, dateOfBirth: $dateOfBirth, gender: $gender, bloodGroup: $bloodGroup, height: $height, weight: $weight, nationality: $nationality, address: $address, city: $city, district: $district, state: $state, country: $country, pinCode: $pinCode, occupation: $occupation, aadhaar: $aadhaar, emergencyNotes: $emergencyNotes)';
}


}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res> implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(_UserProfile value, $Res Function(_UserProfile) _then) = __$UserProfileCopyWithImpl;
@override @useResult
$Res call({
 String photoPath, String fullName, String nickname, DateTime? dateOfBirth, String gender, String bloodGroup, double height, double weight, String nationality, String address, String city, String district, String state, String country, String pinCode, String occupation, String? aadhaar, String emergencyNotes
});




}
/// @nodoc
class __$UserProfileCopyWithImpl<$Res>
    implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

/// Create a copy of UserProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? photoPath = null,Object? fullName = null,Object? nickname = null,Object? dateOfBirth = freezed,Object? gender = null,Object? bloodGroup = null,Object? height = null,Object? weight = null,Object? nationality = null,Object? address = null,Object? city = null,Object? district = null,Object? state = null,Object? country = null,Object? pinCode = null,Object? occupation = null,Object? aadhaar = freezed,Object? emergencyNotes = null,}) {
  return _then(_UserProfile(
photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: freezed == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime?,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,bloodGroup: null == bloodGroup ? _self.bloodGroup : bloodGroup // ignore: cast_nullable_to_non_nullable
as String,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,nationality: null == nationality ? _self.nationality : nationality // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,district: null == district ? _self.district : district // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,country: null == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String,pinCode: null == pinCode ? _self.pinCode : pinCode // ignore: cast_nullable_to_non_nullable
as String,occupation: null == occupation ? _self.occupation : occupation // ignore: cast_nullable_to_non_nullable
as String,aadhaar: freezed == aadhaar ? _self.aadhaar : aadhaar // ignore: cast_nullable_to_non_nullable
as String?,emergencyNotes: null == emergencyNotes ? _self.emergencyNotes : emergencyNotes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
