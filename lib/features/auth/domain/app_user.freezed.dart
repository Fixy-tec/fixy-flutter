// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get id; String get email; String get fullName; String? get career; int? get cycle; String? get bio; String? get avatarUrl; String? get avatarSlug; String? get whatsappNumber; String? get portfolioUrl; String? get linkedinUrl; String? get githubUrl; int get totalPoints; Medal get medal; num get avgRating; int get ratingsCount; bool get isActive;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.career, career) || other.career == career)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.avatarSlug, avatarSlug) || other.avatarSlug == avatarSlug)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.portfolioUrl, portfolioUrl) || other.portfolioUrl == portfolioUrl)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.githubUrl, githubUrl) || other.githubUrl == githubUrl)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.medal, medal) || other.medal == medal)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,career,cycle,bio,avatarUrl,avatarSlug,whatsappNumber,portfolioUrl,linkedinUrl,githubUrl,totalPoints,medal,avgRating,ratingsCount,isActive);

@override
String toString() {
  return 'AppUser(id: $id, email: $email, fullName: $fullName, career: $career, cycle: $cycle, bio: $bio, avatarUrl: $avatarUrl, avatarSlug: $avatarSlug, whatsappNumber: $whatsappNumber, portfolioUrl: $portfolioUrl, linkedinUrl: $linkedinUrl, githubUrl: $githubUrl, totalPoints: $totalPoints, medal: $medal, avgRating: $avgRating, ratingsCount: $ratingsCount, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String id, String email, String fullName, String? career, int? cycle, String? bio, String? avatarUrl, String? avatarSlug, String? whatsappNumber, String? portfolioUrl, String? linkedinUrl, String? githubUrl, int totalPoints, Medal medal, num avgRating, int ratingsCount, bool isActive
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? career = freezed,Object? cycle = freezed,Object? bio = freezed,Object? avatarUrl = freezed,Object? avatarSlug = freezed,Object? whatsappNumber = freezed,Object? portfolioUrl = freezed,Object? linkedinUrl = freezed,Object? githubUrl = freezed,Object? totalPoints = null,Object? medal = null,Object? avgRating = null,Object? ratingsCount = null,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,career: freezed == career ? _self.career : career // ignore: cast_nullable_to_non_nullable
as String?,cycle: freezed == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as int?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarSlug: freezed == avatarSlug ? _self.avatarSlug : avatarSlug // ignore: cast_nullable_to_non_nullable
as String?,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,portfolioUrl: freezed == portfolioUrl ? _self.portfolioUrl : portfolioUrl // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,githubUrl: freezed == githubUrl ? _self.githubUrl : githubUrl // ignore: cast_nullable_to_non_nullable
as String?,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as num,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String fullName,  String? career,  int? cycle,  String? bio,  String? avatarUrl,  String? avatarSlug,  String? whatsappNumber,  String? portfolioUrl,  String? linkedinUrl,  String? githubUrl,  int totalPoints,  Medal medal,  num avgRating,  int ratingsCount,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.career,_that.cycle,_that.bio,_that.avatarUrl,_that.avatarSlug,_that.whatsappNumber,_that.portfolioUrl,_that.linkedinUrl,_that.githubUrl,_that.totalPoints,_that.medal,_that.avgRating,_that.ratingsCount,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String fullName,  String? career,  int? cycle,  String? bio,  String? avatarUrl,  String? avatarSlug,  String? whatsappNumber,  String? portfolioUrl,  String? linkedinUrl,  String? githubUrl,  int totalPoints,  Medal medal,  num avgRating,  int ratingsCount,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.id,_that.email,_that.fullName,_that.career,_that.cycle,_that.bio,_that.avatarUrl,_that.avatarSlug,_that.whatsappNumber,_that.portfolioUrl,_that.linkedinUrl,_that.githubUrl,_that.totalPoints,_that.medal,_that.avgRating,_that.ratingsCount,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String fullName,  String? career,  int? cycle,  String? bio,  String? avatarUrl,  String? avatarSlug,  String? whatsappNumber,  String? portfolioUrl,  String? linkedinUrl,  String? githubUrl,  int totalPoints,  Medal medal,  num avgRating,  int ratingsCount,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.id,_that.email,_that.fullName,_that.career,_that.cycle,_that.bio,_that.avatarUrl,_that.avatarSlug,_that.whatsappNumber,_that.portfolioUrl,_that.linkedinUrl,_that.githubUrl,_that.totalPoints,_that.medal,_that.avgRating,_that.ratingsCount,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser implements AppUser {
  const _AppUser({required this.id, required this.email, required this.fullName, this.career, this.cycle, this.bio, this.avatarUrl, this.avatarSlug, this.whatsappNumber, this.portfolioUrl, this.linkedinUrl, this.githubUrl, this.totalPoints = 0, this.medal = Medal.hierro, this.avgRating = 0, this.ratingsCount = 0, this.isActive = true});
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String id;
@override final  String email;
@override final  String fullName;
@override final  String? career;
@override final  int? cycle;
@override final  String? bio;
@override final  String? avatarUrl;
@override final  String? avatarSlug;
@override final  String? whatsappNumber;
@override final  String? portfolioUrl;
@override final  String? linkedinUrl;
@override final  String? githubUrl;
@override@JsonKey() final  int totalPoints;
@override@JsonKey() final  Medal medal;
@override@JsonKey() final  num avgRating;
@override@JsonKey() final  int ratingsCount;
@override@JsonKey() final  bool isActive;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.career, career) || other.career == career)&&(identical(other.cycle, cycle) || other.cycle == cycle)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.avatarSlug, avatarSlug) || other.avatarSlug == avatarSlug)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.portfolioUrl, portfolioUrl) || other.portfolioUrl == portfolioUrl)&&(identical(other.linkedinUrl, linkedinUrl) || other.linkedinUrl == linkedinUrl)&&(identical(other.githubUrl, githubUrl) || other.githubUrl == githubUrl)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.medal, medal) || other.medal == medal)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,fullName,career,cycle,bio,avatarUrl,avatarSlug,whatsappNumber,portfolioUrl,linkedinUrl,githubUrl,totalPoints,medal,avgRating,ratingsCount,isActive);

@override
String toString() {
  return 'AppUser(id: $id, email: $email, fullName: $fullName, career: $career, cycle: $cycle, bio: $bio, avatarUrl: $avatarUrl, avatarSlug: $avatarSlug, whatsappNumber: $whatsappNumber, portfolioUrl: $portfolioUrl, linkedinUrl: $linkedinUrl, githubUrl: $githubUrl, totalPoints: $totalPoints, medal: $medal, avgRating: $avgRating, ratingsCount: $ratingsCount, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String fullName, String? career, int? cycle, String? bio, String? avatarUrl, String? avatarSlug, String? whatsappNumber, String? portfolioUrl, String? linkedinUrl, String? githubUrl, int totalPoints, Medal medal, num avgRating, int ratingsCount, bool isActive
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? fullName = null,Object? career = freezed,Object? cycle = freezed,Object? bio = freezed,Object? avatarUrl = freezed,Object? avatarSlug = freezed,Object? whatsappNumber = freezed,Object? portfolioUrl = freezed,Object? linkedinUrl = freezed,Object? githubUrl = freezed,Object? totalPoints = null,Object? medal = null,Object? avgRating = null,Object? ratingsCount = null,Object? isActive = null,}) {
  return _then(_AppUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,career: freezed == career ? _self.career : career // ignore: cast_nullable_to_non_nullable
as String?,cycle: freezed == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as int?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarSlug: freezed == avatarSlug ? _self.avatarSlug : avatarSlug // ignore: cast_nullable_to_non_nullable
as String?,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,portfolioUrl: freezed == portfolioUrl ? _self.portfolioUrl : portfolioUrl // ignore: cast_nullable_to_non_nullable
as String?,linkedinUrl: freezed == linkedinUrl ? _self.linkedinUrl : linkedinUrl // ignore: cast_nullable_to_non_nullable
as String?,githubUrl: freezed == githubUrl ? _self.githubUrl : githubUrl // ignore: cast_nullable_to_non_nullable
as String?,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as num,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
