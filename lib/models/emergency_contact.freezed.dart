// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'emergency_contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmergencyContact {

 String get id; String get photoPath; String get name; String get relationship; String get primaryPhone; String get alternativePhone; String get email; String get address; int get priority; bool get isFavorite; String get notes; bool get sendSmsOnSos;
/// Create a copy of EmergencyContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmergencyContactCopyWith<EmergencyContact> get copyWith => _$EmergencyContactCopyWithImpl<EmergencyContact>(this as EmergencyContact, _$identity);

  /// Serializes this EmergencyContact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmergencyContact&&(identical(other.id, id) || other.id == id)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.name, name) || other.name == name)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.primaryPhone, primaryPhone) || other.primaryPhone == primaryPhone)&&(identical(other.alternativePhone, alternativePhone) || other.alternativePhone == alternativePhone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.sendSmsOnSos, sendSmsOnSos) || other.sendSmsOnSos == sendSmsOnSos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,photoPath,name,relationship,primaryPhone,alternativePhone,email,address,priority,isFavorite,notes,sendSmsOnSos);

@override
String toString() {
  return 'EmergencyContact(id: $id, photoPath: $photoPath, name: $name, relationship: $relationship, primaryPhone: $primaryPhone, alternativePhone: $alternativePhone, email: $email, address: $address, priority: $priority, isFavorite: $isFavorite, notes: $notes, sendSmsOnSos: $sendSmsOnSos)';
}


}

/// @nodoc
abstract mixin class $EmergencyContactCopyWith<$Res>  {
  factory $EmergencyContactCopyWith(EmergencyContact value, $Res Function(EmergencyContact) _then) = _$EmergencyContactCopyWithImpl;
@useResult
$Res call({
 String id, String photoPath, String name, String relationship, String primaryPhone, String alternativePhone, String email, String address, int priority, bool isFavorite, String notes, bool sendSmsOnSos
});




}
/// @nodoc
class _$EmergencyContactCopyWithImpl<$Res>
    implements $EmergencyContactCopyWith<$Res> {
  _$EmergencyContactCopyWithImpl(this._self, this._then);

  final EmergencyContact _self;
  final $Res Function(EmergencyContact) _then;

/// Create a copy of EmergencyContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? photoPath = null,Object? name = null,Object? relationship = null,Object? primaryPhone = null,Object? alternativePhone = null,Object? email = null,Object? address = null,Object? priority = null,Object? isFavorite = null,Object? notes = null,Object? sendSmsOnSos = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,primaryPhone: null == primaryPhone ? _self.primaryPhone : primaryPhone // ignore: cast_nullable_to_non_nullable
as String,alternativePhone: null == alternativePhone ? _self.alternativePhone : alternativePhone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,sendSmsOnSos: null == sendSmsOnSos ? _self.sendSmsOnSos : sendSmsOnSos // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EmergencyContact].
extension EmergencyContactPatterns on EmergencyContact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmergencyContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmergencyContact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmergencyContact value)  $default,){
final _that = this;
switch (_that) {
case _EmergencyContact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmergencyContact value)?  $default,){
final _that = this;
switch (_that) {
case _EmergencyContact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String photoPath,  String name,  String relationship,  String primaryPhone,  String alternativePhone,  String email,  String address,  int priority,  bool isFavorite,  String notes,  bool sendSmsOnSos)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmergencyContact() when $default != null:
return $default(_that.id,_that.photoPath,_that.name,_that.relationship,_that.primaryPhone,_that.alternativePhone,_that.email,_that.address,_that.priority,_that.isFavorite,_that.notes,_that.sendSmsOnSos);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String photoPath,  String name,  String relationship,  String primaryPhone,  String alternativePhone,  String email,  String address,  int priority,  bool isFavorite,  String notes,  bool sendSmsOnSos)  $default,) {final _that = this;
switch (_that) {
case _EmergencyContact():
return $default(_that.id,_that.photoPath,_that.name,_that.relationship,_that.primaryPhone,_that.alternativePhone,_that.email,_that.address,_that.priority,_that.isFavorite,_that.notes,_that.sendSmsOnSos);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String photoPath,  String name,  String relationship,  String primaryPhone,  String alternativePhone,  String email,  String address,  int priority,  bool isFavorite,  String notes,  bool sendSmsOnSos)?  $default,) {final _that = this;
switch (_that) {
case _EmergencyContact() when $default != null:
return $default(_that.id,_that.photoPath,_that.name,_that.relationship,_that.primaryPhone,_that.alternativePhone,_that.email,_that.address,_that.priority,_that.isFavorite,_that.notes,_that.sendSmsOnSos);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmergencyContact implements EmergencyContact {
  const _EmergencyContact({required this.id, this.photoPath = '', this.name = '', this.relationship = '', this.primaryPhone = '', this.alternativePhone = '', this.email = '', this.address = '', this.priority = 0, this.isFavorite = false, this.notes = '', this.sendSmsOnSos = true});
  factory _EmergencyContact.fromJson(Map<String, dynamic> json) => _$EmergencyContactFromJson(json);

@override final  String id;
@override@JsonKey() final  String photoPath;
@override@JsonKey() final  String name;
@override@JsonKey() final  String relationship;
@override@JsonKey() final  String primaryPhone;
@override@JsonKey() final  String alternativePhone;
@override@JsonKey() final  String email;
@override@JsonKey() final  String address;
@override@JsonKey() final  int priority;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  String notes;
@override@JsonKey() final  bool sendSmsOnSos;

/// Create a copy of EmergencyContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmergencyContactCopyWith<_EmergencyContact> get copyWith => __$EmergencyContactCopyWithImpl<_EmergencyContact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmergencyContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmergencyContact&&(identical(other.id, id) || other.id == id)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.name, name) || other.name == name)&&(identical(other.relationship, relationship) || other.relationship == relationship)&&(identical(other.primaryPhone, primaryPhone) || other.primaryPhone == primaryPhone)&&(identical(other.alternativePhone, alternativePhone) || other.alternativePhone == alternativePhone)&&(identical(other.email, email) || other.email == email)&&(identical(other.address, address) || other.address == address)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.sendSmsOnSos, sendSmsOnSos) || other.sendSmsOnSos == sendSmsOnSos));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,photoPath,name,relationship,primaryPhone,alternativePhone,email,address,priority,isFavorite,notes,sendSmsOnSos);

@override
String toString() {
  return 'EmergencyContact(id: $id, photoPath: $photoPath, name: $name, relationship: $relationship, primaryPhone: $primaryPhone, alternativePhone: $alternativePhone, email: $email, address: $address, priority: $priority, isFavorite: $isFavorite, notes: $notes, sendSmsOnSos: $sendSmsOnSos)';
}


}

/// @nodoc
abstract mixin class _$EmergencyContactCopyWith<$Res> implements $EmergencyContactCopyWith<$Res> {
  factory _$EmergencyContactCopyWith(_EmergencyContact value, $Res Function(_EmergencyContact) _then) = __$EmergencyContactCopyWithImpl;
@override @useResult
$Res call({
 String id, String photoPath, String name, String relationship, String primaryPhone, String alternativePhone, String email, String address, int priority, bool isFavorite, String notes, bool sendSmsOnSos
});




}
/// @nodoc
class __$EmergencyContactCopyWithImpl<$Res>
    implements _$EmergencyContactCopyWith<$Res> {
  __$EmergencyContactCopyWithImpl(this._self, this._then);

  final _EmergencyContact _self;
  final $Res Function(_EmergencyContact) _then;

/// Create a copy of EmergencyContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? photoPath = null,Object? name = null,Object? relationship = null,Object? primaryPhone = null,Object? alternativePhone = null,Object? email = null,Object? address = null,Object? priority = null,Object? isFavorite = null,Object? notes = null,Object? sendSmsOnSos = null,}) {
  return _then(_EmergencyContact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,photoPath: null == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,relationship: null == relationship ? _self.relationship : relationship // ignore: cast_nullable_to_non_nullable
as String,primaryPhone: null == primaryPhone ? _self.primaryPhone : primaryPhone // ignore: cast_nullable_to_non_nullable
as String,alternativePhone: null == alternativePhone ? _self.alternativePhone : alternativePhone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,sendSmsOnSos: null == sendSmsOnSos ? _self.sendSmsOnSos : sendSmsOnSos // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
