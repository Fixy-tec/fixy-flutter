// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'applicant_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplicantInfo {

 String get applicationId; String get applicantId; String get fullName; String? get avatarUrl; Medal get medal; num get avgRating; int get ratingsCount; int get totalPoints; String? get message; ApplicationStatus get status; String? get whatsappNumber; DateTime get appliedAt;
/// Create a copy of ApplicantInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicantInfoCopyWith<ApplicantInfo> get copyWith => _$ApplicantInfoCopyWithImpl<ApplicantInfo>(this as ApplicantInfo, _$identity);

  /// Serializes this ApplicantInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicantInfo&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.applicantId, applicantId) || other.applicantId == applicantId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.medal, medal) || other.medal == medal)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,applicantId,fullName,avatarUrl,medal,avgRating,ratingsCount,totalPoints,message,status,whatsappNumber,appliedAt);

@override
String toString() {
  return 'ApplicantInfo(applicationId: $applicationId, applicantId: $applicantId, fullName: $fullName, avatarUrl: $avatarUrl, medal: $medal, avgRating: $avgRating, ratingsCount: $ratingsCount, totalPoints: $totalPoints, message: $message, status: $status, whatsappNumber: $whatsappNumber, appliedAt: $appliedAt)';
}


}

/// @nodoc
abstract mixin class $ApplicantInfoCopyWith<$Res>  {
  factory $ApplicantInfoCopyWith(ApplicantInfo value, $Res Function(ApplicantInfo) _then) = _$ApplicantInfoCopyWithImpl;
@useResult
$Res call({
 String applicationId, String applicantId, String fullName, String? avatarUrl, Medal medal, num avgRating, int ratingsCount, int totalPoints, String? message, ApplicationStatus status, String? whatsappNumber, DateTime appliedAt
});




}
/// @nodoc
class _$ApplicantInfoCopyWithImpl<$Res>
    implements $ApplicantInfoCopyWith<$Res> {
  _$ApplicantInfoCopyWithImpl(this._self, this._then);

  final ApplicantInfo _self;
  final $Res Function(ApplicantInfo) _then;

/// Create a copy of ApplicantInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? applicationId = null,Object? applicantId = null,Object? fullName = null,Object? avatarUrl = freezed,Object? medal = null,Object? avgRating = null,Object? ratingsCount = null,Object? totalPoints = null,Object? message = freezed,Object? status = null,Object? whatsappNumber = freezed,Object? appliedAt = null,}) {
  return _then(_self.copyWith(
applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,applicantId: null == applicantId ? _self.applicantId : applicantId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as num,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: null == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplicantInfo].
extension ApplicantInfoPatterns on ApplicantInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicantInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicantInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicantInfo value)  $default,){
final _that = this;
switch (_that) {
case _ApplicantInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicantInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicantInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String applicationId,  String applicantId,  String fullName,  String? avatarUrl,  Medal medal,  num avgRating,  int ratingsCount,  int totalPoints,  String? message,  ApplicationStatus status,  String? whatsappNumber,  DateTime appliedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicantInfo() when $default != null:
return $default(_that.applicationId,_that.applicantId,_that.fullName,_that.avatarUrl,_that.medal,_that.avgRating,_that.ratingsCount,_that.totalPoints,_that.message,_that.status,_that.whatsappNumber,_that.appliedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String applicationId,  String applicantId,  String fullName,  String? avatarUrl,  Medal medal,  num avgRating,  int ratingsCount,  int totalPoints,  String? message,  ApplicationStatus status,  String? whatsappNumber,  DateTime appliedAt)  $default,) {final _that = this;
switch (_that) {
case _ApplicantInfo():
return $default(_that.applicationId,_that.applicantId,_that.fullName,_that.avatarUrl,_that.medal,_that.avgRating,_that.ratingsCount,_that.totalPoints,_that.message,_that.status,_that.whatsappNumber,_that.appliedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String applicationId,  String applicantId,  String fullName,  String? avatarUrl,  Medal medal,  num avgRating,  int ratingsCount,  int totalPoints,  String? message,  ApplicationStatus status,  String? whatsappNumber,  DateTime appliedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApplicantInfo() when $default != null:
return $default(_that.applicationId,_that.applicantId,_that.fullName,_that.avatarUrl,_that.medal,_that.avgRating,_that.ratingsCount,_that.totalPoints,_that.message,_that.status,_that.whatsappNumber,_that.appliedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplicantInfo implements ApplicantInfo {
  const _ApplicantInfo({required this.applicationId, required this.applicantId, required this.fullName, this.avatarUrl, this.medal = Medal.hierro, this.avgRating = 0, this.ratingsCount = 0, this.totalPoints = 0, this.message, required this.status, this.whatsappNumber, required this.appliedAt});
  factory _ApplicantInfo.fromJson(Map<String, dynamic> json) => _$ApplicantInfoFromJson(json);

@override final  String applicationId;
@override final  String applicantId;
@override final  String fullName;
@override final  String? avatarUrl;
@override@JsonKey() final  Medal medal;
@override@JsonKey() final  num avgRating;
@override@JsonKey() final  int ratingsCount;
@override@JsonKey() final  int totalPoints;
@override final  String? message;
@override final  ApplicationStatus status;
@override final  String? whatsappNumber;
@override final  DateTime appliedAt;

/// Create a copy of ApplicantInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicantInfoCopyWith<_ApplicantInfo> get copyWith => __$ApplicantInfoCopyWithImpl<_ApplicantInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicantInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicantInfo&&(identical(other.applicationId, applicationId) || other.applicationId == applicationId)&&(identical(other.applicantId, applicantId) || other.applicantId == applicantId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.medal, medal) || other.medal == medal)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount)&&(identical(other.totalPoints, totalPoints) || other.totalPoints == totalPoints)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,applicationId,applicantId,fullName,avatarUrl,medal,avgRating,ratingsCount,totalPoints,message,status,whatsappNumber,appliedAt);

@override
String toString() {
  return 'ApplicantInfo(applicationId: $applicationId, applicantId: $applicantId, fullName: $fullName, avatarUrl: $avatarUrl, medal: $medal, avgRating: $avgRating, ratingsCount: $ratingsCount, totalPoints: $totalPoints, message: $message, status: $status, whatsappNumber: $whatsappNumber, appliedAt: $appliedAt)';
}


}

/// @nodoc
abstract mixin class _$ApplicantInfoCopyWith<$Res> implements $ApplicantInfoCopyWith<$Res> {
  factory _$ApplicantInfoCopyWith(_ApplicantInfo value, $Res Function(_ApplicantInfo) _then) = __$ApplicantInfoCopyWithImpl;
@override @useResult
$Res call({
 String applicationId, String applicantId, String fullName, String? avatarUrl, Medal medal, num avgRating, int ratingsCount, int totalPoints, String? message, ApplicationStatus status, String? whatsappNumber, DateTime appliedAt
});




}
/// @nodoc
class __$ApplicantInfoCopyWithImpl<$Res>
    implements _$ApplicantInfoCopyWith<$Res> {
  __$ApplicantInfoCopyWithImpl(this._self, this._then);

  final _ApplicantInfo _self;
  final $Res Function(_ApplicantInfo) _then;

/// Create a copy of ApplicantInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? applicationId = null,Object? applicantId = null,Object? fullName = null,Object? avatarUrl = freezed,Object? medal = null,Object? avgRating = null,Object? ratingsCount = null,Object? totalPoints = null,Object? message = freezed,Object? status = null,Object? whatsappNumber = freezed,Object? appliedAt = null,}) {
  return _then(_ApplicantInfo(
applicationId: null == applicationId ? _self.applicationId : applicationId // ignore: cast_nullable_to_non_nullable
as String,applicantId: null == applicantId ? _self.applicantId : applicantId // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as num,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,totalPoints: null == totalPoints ? _self.totalPoints : totalPoints // ignore: cast_nullable_to_non_nullable
as int,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: null == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
