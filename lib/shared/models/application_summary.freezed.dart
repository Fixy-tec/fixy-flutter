// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApplicationSummary {

 String get id; String get requestId; String get applicantId; String? get message; ApplicationStatus get status; DateTime get appliedAt; RequestSummary get request;
/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationSummaryCopyWith<ApplicationSummary> get copyWith => _$ApplicationSummaryCopyWithImpl<ApplicationSummary>(this as ApplicationSummary, _$identity);

  /// Serializes this ApplicationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.applicantId, applicantId) || other.applicantId == applicantId)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.request, request) || other.request == request));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,applicantId,message,status,appliedAt,request);

@override
String toString() {
  return 'ApplicationSummary(id: $id, requestId: $requestId, applicantId: $applicantId, message: $message, status: $status, appliedAt: $appliedAt, request: $request)';
}


}

/// @nodoc
abstract mixin class $ApplicationSummaryCopyWith<$Res>  {
  factory $ApplicationSummaryCopyWith(ApplicationSummary value, $Res Function(ApplicationSummary) _then) = _$ApplicationSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String requestId, String applicantId, String? message, ApplicationStatus status, DateTime appliedAt, RequestSummary request
});


$RequestSummaryCopyWith<$Res> get request;

}
/// @nodoc
class _$ApplicationSummaryCopyWithImpl<$Res>
    implements $ApplicationSummaryCopyWith<$Res> {
  _$ApplicationSummaryCopyWithImpl(this._self, this._then);

  final ApplicationSummary _self;
  final $Res Function(ApplicationSummary) _then;

/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestId = null,Object? applicantId = null,Object? message = freezed,Object? status = null,Object? appliedAt = null,Object? request = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,applicantId: null == applicantId ? _self.applicantId : applicantId // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,appliedAt: null == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime,request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as RequestSummary,
  ));
}
/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestSummaryCopyWith<$Res> get request {
  
  return $RequestSummaryCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}


/// Adds pattern-matching-related methods to [ApplicationSummary].
extension ApplicationSummaryPatterns on ApplicationSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicationSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicationSummary value)  $default,){
final _that = this;
switch (_that) {
case _ApplicationSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicationSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String requestId,  String applicantId,  String? message,  ApplicationStatus status,  DateTime appliedAt,  RequestSummary request)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicationSummary() when $default != null:
return $default(_that.id,_that.requestId,_that.applicantId,_that.message,_that.status,_that.appliedAt,_that.request);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String requestId,  String applicantId,  String? message,  ApplicationStatus status,  DateTime appliedAt,  RequestSummary request)  $default,) {final _that = this;
switch (_that) {
case _ApplicationSummary():
return $default(_that.id,_that.requestId,_that.applicantId,_that.message,_that.status,_that.appliedAt,_that.request);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String requestId,  String applicantId,  String? message,  ApplicationStatus status,  DateTime appliedAt,  RequestSummary request)?  $default,) {final _that = this;
switch (_that) {
case _ApplicationSummary() when $default != null:
return $default(_that.id,_that.requestId,_that.applicantId,_that.message,_that.status,_that.appliedAt,_that.request);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApplicationSummary implements ApplicationSummary {
  const _ApplicationSummary({required this.id, required this.requestId, required this.applicantId, this.message, required this.status, required this.appliedAt, required this.request});
  factory _ApplicationSummary.fromJson(Map<String, dynamic> json) => _$ApplicationSummaryFromJson(json);

@override final  String id;
@override final  String requestId;
@override final  String applicantId;
@override final  String? message;
@override final  ApplicationStatus status;
@override final  DateTime appliedAt;
@override final  RequestSummary request;

/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationSummaryCopyWith<_ApplicationSummary> get copyWith => __$ApplicationSummaryCopyWithImpl<_ApplicationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.applicantId, applicantId) || other.applicantId == applicantId)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.request, request) || other.request == request));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,requestId,applicantId,message,status,appliedAt,request);

@override
String toString() {
  return 'ApplicationSummary(id: $id, requestId: $requestId, applicantId: $applicantId, message: $message, status: $status, appliedAt: $appliedAt, request: $request)';
}


}

/// @nodoc
abstract mixin class _$ApplicationSummaryCopyWith<$Res> implements $ApplicationSummaryCopyWith<$Res> {
  factory _$ApplicationSummaryCopyWith(_ApplicationSummary value, $Res Function(_ApplicationSummary) _then) = __$ApplicationSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String requestId, String applicantId, String? message, ApplicationStatus status, DateTime appliedAt, RequestSummary request
});


@override $RequestSummaryCopyWith<$Res> get request;

}
/// @nodoc
class __$ApplicationSummaryCopyWithImpl<$Res>
    implements _$ApplicationSummaryCopyWith<$Res> {
  __$ApplicationSummaryCopyWithImpl(this._self, this._then);

  final _ApplicationSummary _self;
  final $Res Function(_ApplicationSummary) _then;

/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = null,Object? applicantId = null,Object? message = freezed,Object? status = null,Object? appliedAt = null,Object? request = null,}) {
  return _then(_ApplicationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,applicantId: null == applicantId ? _self.applicantId : applicantId // ignore: cast_nullable_to_non_nullable
as String,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,appliedAt: null == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime,request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as RequestSummary,
  ));
}

/// Create a copy of ApplicationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestSummaryCopyWith<$Res> get request {
  
  return $RequestSummaryCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

// dart format on
