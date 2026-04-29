// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_received.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RatingReceived {

 String get id; String get raterId; String get raterFullName; Medal get raterMedal; int get stars; String? get comment; DateTime get createdAt;
/// Create a copy of RatingReceived
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingReceivedCopyWith<RatingReceived> get copyWith => _$RatingReceivedCopyWithImpl<RatingReceived>(this as RatingReceived, _$identity);

  /// Serializes this RatingReceived to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingReceived&&(identical(other.id, id) || other.id == id)&&(identical(other.raterId, raterId) || other.raterId == raterId)&&(identical(other.raterFullName, raterFullName) || other.raterFullName == raterFullName)&&(identical(other.raterMedal, raterMedal) || other.raterMedal == raterMedal)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,raterId,raterFullName,raterMedal,stars,comment,createdAt);

@override
String toString() {
  return 'RatingReceived(id: $id, raterId: $raterId, raterFullName: $raterFullName, raterMedal: $raterMedal, stars: $stars, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $RatingReceivedCopyWith<$Res>  {
  factory $RatingReceivedCopyWith(RatingReceived value, $Res Function(RatingReceived) _then) = _$RatingReceivedCopyWithImpl;
@useResult
$Res call({
 String id, String raterId, String raterFullName, Medal raterMedal, int stars, String? comment, DateTime createdAt
});




}
/// @nodoc
class _$RatingReceivedCopyWithImpl<$Res>
    implements $RatingReceivedCopyWith<$Res> {
  _$RatingReceivedCopyWithImpl(this._self, this._then);

  final RatingReceived _self;
  final $Res Function(RatingReceived) _then;

/// Create a copy of RatingReceived
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? raterId = null,Object? raterFullName = null,Object? raterMedal = null,Object? stars = null,Object? comment = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,raterId: null == raterId ? _self.raterId : raterId // ignore: cast_nullable_to_non_nullable
as String,raterFullName: null == raterFullName ? _self.raterFullName : raterFullName // ignore: cast_nullable_to_non_nullable
as String,raterMedal: null == raterMedal ? _self.raterMedal : raterMedal // ignore: cast_nullable_to_non_nullable
as Medal,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RatingReceived].
extension RatingReceivedPatterns on RatingReceived {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RatingReceived value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RatingReceived() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RatingReceived value)  $default,){
final _that = this;
switch (_that) {
case _RatingReceived():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RatingReceived value)?  $default,){
final _that = this;
switch (_that) {
case _RatingReceived() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String raterId,  String raterFullName,  Medal raterMedal,  int stars,  String? comment,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RatingReceived() when $default != null:
return $default(_that.id,_that.raterId,_that.raterFullName,_that.raterMedal,_that.stars,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String raterId,  String raterFullName,  Medal raterMedal,  int stars,  String? comment,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RatingReceived():
return $default(_that.id,_that.raterId,_that.raterFullName,_that.raterMedal,_that.stars,_that.comment,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String raterId,  String raterFullName,  Medal raterMedal,  int stars,  String? comment,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RatingReceived() when $default != null:
return $default(_that.id,_that.raterId,_that.raterFullName,_that.raterMedal,_that.stars,_that.comment,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RatingReceived implements RatingReceived {
  const _RatingReceived({required this.id, required this.raterId, required this.raterFullName, this.raterMedal = Medal.hierro, required this.stars, this.comment, required this.createdAt});
  factory _RatingReceived.fromJson(Map<String, dynamic> json) => _$RatingReceivedFromJson(json);

@override final  String id;
@override final  String raterId;
@override final  String raterFullName;
@override@JsonKey() final  Medal raterMedal;
@override final  int stars;
@override final  String? comment;
@override final  DateTime createdAt;

/// Create a copy of RatingReceived
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RatingReceivedCopyWith<_RatingReceived> get copyWith => __$RatingReceivedCopyWithImpl<_RatingReceived>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RatingReceivedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RatingReceived&&(identical(other.id, id) || other.id == id)&&(identical(other.raterId, raterId) || other.raterId == raterId)&&(identical(other.raterFullName, raterFullName) || other.raterFullName == raterFullName)&&(identical(other.raterMedal, raterMedal) || other.raterMedal == raterMedal)&&(identical(other.stars, stars) || other.stars == stars)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,raterId,raterFullName,raterMedal,stars,comment,createdAt);

@override
String toString() {
  return 'RatingReceived(id: $id, raterId: $raterId, raterFullName: $raterFullName, raterMedal: $raterMedal, stars: $stars, comment: $comment, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RatingReceivedCopyWith<$Res> implements $RatingReceivedCopyWith<$Res> {
  factory _$RatingReceivedCopyWith(_RatingReceived value, $Res Function(_RatingReceived) _then) = __$RatingReceivedCopyWithImpl;
@override @useResult
$Res call({
 String id, String raterId, String raterFullName, Medal raterMedal, int stars, String? comment, DateTime createdAt
});




}
/// @nodoc
class __$RatingReceivedCopyWithImpl<$Res>
    implements _$RatingReceivedCopyWith<$Res> {
  __$RatingReceivedCopyWithImpl(this._self, this._then);

  final _RatingReceived _self;
  final $Res Function(_RatingReceived) _then;

/// Create a copy of RatingReceived
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? raterId = null,Object? raterFullName = null,Object? raterMedal = null,Object? stars = null,Object? comment = freezed,Object? createdAt = null,}) {
  return _then(_RatingReceived(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,raterId: null == raterId ? _self.raterId : raterId // ignore: cast_nullable_to_non_nullable
as String,raterFullName: null == raterFullName ? _self.raterFullName : raterFullName // ignore: cast_nullable_to_non_nullable
as String,raterMedal: null == raterMedal ? _self.raterMedal : raterMedal // ignore: cast_nullable_to_non_nullable
as Medal,stars: null == stars ? _self.stars : stars // ignore: cast_nullable_to_non_nullable
as int,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
