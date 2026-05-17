// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ranking_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RankingUser {

 int get rank; String get id; String get fullName; String? get avatarUrl; String? get avatarSlug; int get totalPoints; Medal get medal;
/// Create a copy of RankingUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankingUserCopyWith<RankingUser> get copyWith => _$RankingUserCopyWithImpl<RankingUser>(this as RankingUser, _$identity);

  /// Serializes this RankingUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankingUser&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.avatarSlug, avatarSlug) || other.avatarSlug == avatarSlug)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.medal, medal) || other.medal == medal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,id,fullName,avatarUrl,avatarSlug,totalPoints,medal);

@override
String toString() {
  return 'RankingUser(rank: $rank, id: $id, fullName: $fullName, avatarUrl: $avatarUrl, avatarSlug: $avatarSlug, totalPoints: $totalPoints, medal: $medal)';
}


}

/// @nodoc
abstract mixin class $RankingUserCopyWith<$Res>  {
  factory $RankingUserCopyWith(RankingUser value, $Res Function(RankingUser) _then) = _$RankingUserCopyWithImpl;
@useResult
$Res call({
 int rank, String id, String fullName, String? avatarUrl, String? avatarSlug, int totalPoints, Medal medal
});




}
/// @nodoc
class _$RankingUserCopyWithImpl<$Res>
    implements $RankingUserCopyWith<$Res> {
  _$RankingUserCopyWithImpl(this._self, this._then);

  final RankingUser _self;
  final $Res Function(RankingUser) _then;

/// Create a copy of RankingUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? avatarSlug = freezed,Object? totalPoints = null,Object? medal = null,}) {
  return _then(_self.copyWith(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarSlug: freezed == avatarSlug ? _self.avatarSlug : avatarSlug // ignore: cast_nullable_to_non_nullable
as String?,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,
  ));
}

}


/// Adds pattern-matching-related methods to [RankingUser].
extension RankingUserPatterns on RankingUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankingUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankingUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankingUser value)  $default,){
final _that = this;
switch (_that) {
case _RankingUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankingUser value)?  $default,){
final _that = this;
switch (_that) {
case _RankingUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  String id,  String fullName,  String? avatarUrl,  String? avatarSlug,  int totalPoints,  Medal medal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankingUser() when $default != null:
return $default(_that.rank,_that.id,_that.fullName,_that.avatarUrl,_that.avatarSlug,_that.totalPoints,_that.medal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  String id,  String fullName,  String? avatarUrl,  String? avatarSlug,  int totalPoints,  Medal medal)  $default,) {final _that = this;
switch (_that) {
case _RankingUser():
return $default(_that.rank,_that.id,_that.fullName,_that.avatarUrl,_that.avatarSlug,_that.totalPoints,_that.medal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  String id,  String fullName,  String? avatarUrl,  String? avatarSlug,  int totalPoints,  Medal medal)?  $default,) {final _that = this;
switch (_that) {
case _RankingUser() when $default != null:
return $default(_that.rank,_that.id,_that.fullName,_that.avatarUrl,_that.avatarSlug,_that.totalPoints,_that.medal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankingUser implements RankingUser {
  const _RankingUser({required this.rank, required this.id, required this.fullName, this.avatarUrl, this.avatarSlug, required this.totalPoints, this.medal = Medal.hierro});
  factory _RankingUser.fromJson(Map<String, dynamic> json) => _$RankingUserFromJson(json);

@override final  int rank;
@override final  String id;
@override final  String fullName;
@override final  String? avatarUrl;
@override final  String? avatarSlug;
@override final  int totalPoints;
@override@JsonKey() final  Medal medal;

/// Create a copy of RankingUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankingUserCopyWith<_RankingUser> get copyWith => __$RankingUserCopyWithImpl<_RankingUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankingUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankingUser&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.avatarSlug, avatarSlug) || other.avatarSlug == avatarSlug)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.medal, medal) || other.medal == medal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,rank,id,fullName,avatarUrl,avatarSlug,totalPoints,medal);

@override
String toString() {
  return 'RankingUser(rank: $rank, id: $id, fullName: $fullName, avatarUrl: $avatarUrl, avatarSlug: $avatarSlug, totalPoints: $totalPoints, medal: $medal)';
}


}

/// @nodoc
abstract mixin class _$RankingUserCopyWith<$Res> implements $RankingUserCopyWith<$Res> {
  factory _$RankingUserCopyWith(_RankingUser value, $Res Function(_RankingUser) _then) = __$RankingUserCopyWithImpl;
@override @useResult
$Res call({
 int rank, String id, String fullName, String? avatarUrl, String? avatarSlug, int totalPoints, Medal medal
});




}
/// @nodoc
class __$RankingUserCopyWithImpl<$Res>
    implements _$RankingUserCopyWith<$Res> {
  __$RankingUserCopyWithImpl(this._self, this._then);

  final _RankingUser _self;
  final $Res Function(_RankingUser) _then;

/// Create a copy of RankingUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? avatarSlug = freezed,Object? totalPoints = null,Object? medal = null,}) {
  return _then(_RankingUser(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarSlug: freezed == avatarSlug ? _self.avatarSlug : avatarSlug // ignore: cast_nullable_to_non_nullable
as String?,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,
  ));
}


}

// dart format on
