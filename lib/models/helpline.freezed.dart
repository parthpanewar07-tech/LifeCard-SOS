// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'helpline.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Helpline {

 String get id; String get name; String get number; String get category; bool get isFavorite; String get notes;
/// Create a copy of Helpline
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HelplineCopyWith<Helpline> get copyWith => _$HelplineCopyWithImpl<Helpline>(this as Helpline, _$identity);

  /// Serializes this Helpline to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Helpline&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.number, number) || other.number == number)&&(identical(other.category, category) || other.category == category)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,number,category,isFavorite,notes);

@override
String toString() {
  return 'Helpline(id: $id, name: $name, number: $number, category: $category, isFavorite: $isFavorite, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $HelplineCopyWith<$Res>  {
  factory $HelplineCopyWith(Helpline value, $Res Function(Helpline) _then) = _$HelplineCopyWithImpl;
@useResult
$Res call({
 String id, String name, String number, String category, bool isFavorite, String notes
});




}
/// @nodoc
class _$HelplineCopyWithImpl<$Res>
    implements $HelplineCopyWith<$Res> {
  _$HelplineCopyWithImpl(this._self, this._then);

  final Helpline _self;
  final $Res Function(Helpline) _then;

/// Create a copy of Helpline
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? number = null,Object? category = null,Object? isFavorite = null,Object? notes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Helpline].
extension HelplinePatterns on Helpline {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Helpline value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Helpline() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Helpline value)  $default,){
final _that = this;
switch (_that) {
case _Helpline():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Helpline value)?  $default,){
final _that = this;
switch (_that) {
case _Helpline() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String number,  String category,  bool isFavorite,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Helpline() when $default != null:
return $default(_that.id,_that.name,_that.number,_that.category,_that.isFavorite,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String number,  String category,  bool isFavorite,  String notes)  $default,) {final _that = this;
switch (_that) {
case _Helpline():
return $default(_that.id,_that.name,_that.number,_that.category,_that.isFavorite,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String number,  String category,  bool isFavorite,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _Helpline() when $default != null:
return $default(_that.id,_that.name,_that.number,_that.category,_that.isFavorite,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Helpline implements Helpline {
  const _Helpline({required this.id, required this.name, required this.number, required this.category, this.isFavorite = false, this.notes = ''});
  factory _Helpline.fromJson(Map<String, dynamic> json) => _$HelplineFromJson(json);

@override final  String id;
@override final  String name;
@override final  String number;
@override final  String category;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  String notes;

/// Create a copy of Helpline
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HelplineCopyWith<_Helpline> get copyWith => __$HelplineCopyWithImpl<_Helpline>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HelplineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Helpline&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.number, number) || other.number == number)&&(identical(other.category, category) || other.category == category)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,number,category,isFavorite,notes);

@override
String toString() {
  return 'Helpline(id: $id, name: $name, number: $number, category: $category, isFavorite: $isFavorite, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$HelplineCopyWith<$Res> implements $HelplineCopyWith<$Res> {
  factory _$HelplineCopyWith(_Helpline value, $Res Function(_Helpline) _then) = __$HelplineCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String number, String category, bool isFavorite, String notes
});




}
/// @nodoc
class __$HelplineCopyWithImpl<$Res>
    implements _$HelplineCopyWith<$Res> {
  __$HelplineCopyWithImpl(this._self, this._then);

  final _Helpline _self;
  final $Res Function(_Helpline) _then;

/// Create a copy of Helpline
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? number = null,Object? category = null,Object? isFavorite = null,Object? notes = null,}) {
  return _then(_Helpline(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
