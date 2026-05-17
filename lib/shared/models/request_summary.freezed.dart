// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RequestCreator {

 String get id; String get fullName; String? get avatarUrl; String? get avatarSlug; Medal get medal; String? get whatsappNumber;
/// Create a copy of RequestCreator
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestCreatorCopyWith<RequestCreator> get copyWith => _$RequestCreatorCopyWithImpl<RequestCreator>(this as RequestCreator, _$identity);

  /// Serializes this RequestCreator to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestCreator&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.avatarSlug, avatarSlug) || other.avatarSlug == avatarSlug)&&(identical(other.medal, medal) || other.medal == medal)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,avatarSlug,medal,whatsappNumber);

@override
String toString() {
  return 'RequestCreator(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, avatarSlug: $avatarSlug, medal: $medal, whatsappNumber: $whatsappNumber)';
}


}

/// @nodoc
abstract mixin class $RequestCreatorCopyWith<$Res>  {
  factory $RequestCreatorCopyWith(RequestCreator value, $Res Function(RequestCreator) _then) = _$RequestCreatorCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? avatarSlug, Medal medal, String? whatsappNumber
});




}
/// @nodoc
class _$RequestCreatorCopyWithImpl<$Res>
    implements $RequestCreatorCopyWith<$Res> {
  _$RequestCreatorCopyWithImpl(this._self, this._then);

  final RequestCreator _self;
  final $Res Function(RequestCreator) _then;

/// Create a copy of RequestCreator
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? avatarSlug = freezed,Object? medal = null,Object? whatsappNumber = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarSlug: freezed == avatarSlug ? _self.avatarSlug : avatarSlug // ignore: cast_nullable_to_non_nullable
as String?,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [RequestCreator].
extension RequestCreatorPatterns on RequestCreator {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestCreator value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestCreator() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestCreator value)  $default,){
final _that = this;
switch (_that) {
case _RequestCreator():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestCreator value)?  $default,){
final _that = this;
switch (_that) {
case _RequestCreator() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String? avatarSlug,  Medal medal,  String? whatsappNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestCreator() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.avatarSlug,_that.medal,_that.whatsappNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? avatarUrl,  String? avatarSlug,  Medal medal,  String? whatsappNumber)  $default,) {final _that = this;
switch (_that) {
case _RequestCreator():
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.avatarSlug,_that.medal,_that.whatsappNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? avatarUrl,  String? avatarSlug,  Medal medal,  String? whatsappNumber)?  $default,) {final _that = this;
switch (_that) {
case _RequestCreator() when $default != null:
return $default(_that.id,_that.fullName,_that.avatarUrl,_that.avatarSlug,_that.medal,_that.whatsappNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestCreator implements RequestCreator {
  const _RequestCreator({required this.id, required this.fullName, this.avatarUrl, this.avatarSlug, this.medal = Medal.hierro, this.whatsappNumber});
  factory _RequestCreator.fromJson(Map<String, dynamic> json) => _$RequestCreatorFromJson(json);

@override final  String id;
@override final  String fullName;
@override final  String? avatarUrl;
@override final  String? avatarSlug;
@override@JsonKey() final  Medal medal;
@override final  String? whatsappNumber;

/// Create a copy of RequestCreator
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestCreatorCopyWith<_RequestCreator> get copyWith => __$RequestCreatorCopyWithImpl<_RequestCreator>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestCreatorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestCreator&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.avatarSlug, avatarSlug) || other.avatarSlug == avatarSlug)&&(identical(other.medal, medal) || other.medal == medal)&&(identical(other.whatsappNumber, whatsappNumber) || other.whatsappNumber == whatsappNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,avatarUrl,avatarSlug,medal,whatsappNumber);

@override
String toString() {
  return 'RequestCreator(id: $id, fullName: $fullName, avatarUrl: $avatarUrl, avatarSlug: $avatarSlug, medal: $medal, whatsappNumber: $whatsappNumber)';
}


}

/// @nodoc
abstract mixin class _$RequestCreatorCopyWith<$Res> implements $RequestCreatorCopyWith<$Res> {
  factory _$RequestCreatorCopyWith(_RequestCreator value, $Res Function(_RequestCreator) _then) = __$RequestCreatorCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? avatarUrl, String? avatarSlug, Medal medal, String? whatsappNumber
});




}
/// @nodoc
class __$RequestCreatorCopyWithImpl<$Res>
    implements _$RequestCreatorCopyWith<$Res> {
  __$RequestCreatorCopyWithImpl(this._self, this._then);

  final _RequestCreator _self;
  final $Res Function(_RequestCreator) _then;

/// Create a copy of RequestCreator
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? avatarUrl = freezed,Object? avatarSlug = freezed,Object? medal = null,Object? whatsappNumber = freezed,}) {
  return _then(_RequestCreator(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,avatarSlug: freezed == avatarSlug ? _self.avatarSlug : avatarSlug // ignore: cast_nullable_to_non_nullable
as String?,medal: null == medal ? _self.medal : medal // ignore: cast_nullable_to_non_nullable
as Medal,whatsappNumber: freezed == whatsappNumber ? _self.whatsappNumber : whatsappNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RequestSummary {

 String get id; RequestType get type; String get title; String get description; int get difficultyLevel; int get basePoints; num? get economicBenefit; int get participantsNeeded; RequestStatus get status; DateTime? get deadline; DateTime get publishedAt; RequestCreator get creator; List<Tag> get tags; int get applicationsCount;
/// Create a copy of RequestSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequestSummaryCopyWith<RequestSummary> get copyWith => _$RequestSummaryCopyWithImpl<RequestSummary>(this as RequestSummary, _$identity);

  /// Serializes this RequestSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.basePoints, basePoints) || other.basePoints == basePoints)&&(identical(other.economicBenefit, economicBenefit) || other.economicBenefit == economicBenefit)&&(identical(other.participantsNeeded, participantsNeeded) || other.participantsNeeded == participantsNeeded)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.creator, creator) || other.creator == creator)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.applicationsCount, applicationsCount) || other.applicationsCount == applicationsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,difficultyLevel,basePoints,economicBenefit,participantsNeeded,status,deadline,publishedAt,creator,const DeepCollectionEquality().hash(tags),applicationsCount);

@override
String toString() {
  return 'RequestSummary(id: $id, type: $type, title: $title, description: $description, difficultyLevel: $difficultyLevel, basePoints: $basePoints, economicBenefit: $economicBenefit, participantsNeeded: $participantsNeeded, status: $status, deadline: $deadline, publishedAt: $publishedAt, creator: $creator, tags: $tags, applicationsCount: $applicationsCount)';
}


}

/// @nodoc
abstract mixin class $RequestSummaryCopyWith<$Res>  {
  factory $RequestSummaryCopyWith(RequestSummary value, $Res Function(RequestSummary) _then) = _$RequestSummaryCopyWithImpl;
@useResult
$Res call({
 String id, RequestType type, String title, String description, int difficultyLevel, int basePoints, num? economicBenefit, int participantsNeeded, RequestStatus status, DateTime? deadline, DateTime publishedAt, RequestCreator creator, List<Tag> tags, int applicationsCount
});


$RequestCreatorCopyWith<$Res> get creator;

}
/// @nodoc
class _$RequestSummaryCopyWithImpl<$Res>
    implements $RequestSummaryCopyWith<$Res> {
  _$RequestSummaryCopyWithImpl(this._self, this._then);

  final RequestSummary _self;
  final $Res Function(RequestSummary) _then;

/// Create a copy of RequestSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? difficultyLevel = null,Object? basePoints = null,Object? economicBenefit = freezed,Object? participantsNeeded = null,Object? status = null,Object? deadline = freezed,Object? publishedAt = null,Object? creator = null,Object? tags = null,Object? applicationsCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RequestType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,difficultyLevel: null == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as int,basePoints: null == basePoints ? _self.basePoints : basePoints // ignore: cast_nullable_to_non_nullable
as int,economicBenefit: freezed == economicBenefit ? _self.economicBenefit : economicBenefit // ignore: cast_nullable_to_non_nullable
as num?,participantsNeeded: null == participantsNeeded ? _self.participantsNeeded : participantsNeeded // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,creator: null == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as RequestCreator,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,applicationsCount: null == applicationsCount ? _self.applicationsCount : applicationsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of RequestSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestCreatorCopyWith<$Res> get creator {
  
  return $RequestCreatorCopyWith<$Res>(_self.creator, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}


/// Adds pattern-matching-related methods to [RequestSummary].
extension RequestSummaryPatterns on RequestSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequestSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequestSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequestSummary value)  $default,){
final _that = this;
switch (_that) {
case _RequestSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequestSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RequestSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  RequestType type,  String title,  String description,  int difficultyLevel,  int basePoints,  num? economicBenefit,  int participantsNeeded,  RequestStatus status,  DateTime? deadline,  DateTime publishedAt,  RequestCreator creator,  List<Tag> tags,  int applicationsCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequestSummary() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.difficultyLevel,_that.basePoints,_that.economicBenefit,_that.participantsNeeded,_that.status,_that.deadline,_that.publishedAt,_that.creator,_that.tags,_that.applicationsCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  RequestType type,  String title,  String description,  int difficultyLevel,  int basePoints,  num? economicBenefit,  int participantsNeeded,  RequestStatus status,  DateTime? deadline,  DateTime publishedAt,  RequestCreator creator,  List<Tag> tags,  int applicationsCount)  $default,) {final _that = this;
switch (_that) {
case _RequestSummary():
return $default(_that.id,_that.type,_that.title,_that.description,_that.difficultyLevel,_that.basePoints,_that.economicBenefit,_that.participantsNeeded,_that.status,_that.deadline,_that.publishedAt,_that.creator,_that.tags,_that.applicationsCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  RequestType type,  String title,  String description,  int difficultyLevel,  int basePoints,  num? economicBenefit,  int participantsNeeded,  RequestStatus status,  DateTime? deadline,  DateTime publishedAt,  RequestCreator creator,  List<Tag> tags,  int applicationsCount)?  $default,) {final _that = this;
switch (_that) {
case _RequestSummary() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.description,_that.difficultyLevel,_that.basePoints,_that.economicBenefit,_that.participantsNeeded,_that.status,_that.deadline,_that.publishedAt,_that.creator,_that.tags,_that.applicationsCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RequestSummary implements RequestSummary {
  const _RequestSummary({required this.id, required this.type, required this.title, required this.description, required this.difficultyLevel, required this.basePoints, this.economicBenefit, this.participantsNeeded = 1, this.status = RequestStatus.abierta, this.deadline, required this.publishedAt, required this.creator, final  List<Tag> tags = const <Tag>[], this.applicationsCount = 0}): _tags = tags;
  factory _RequestSummary.fromJson(Map<String, dynamic> json) => _$RequestSummaryFromJson(json);

@override final  String id;
@override final  RequestType type;
@override final  String title;
@override final  String description;
@override final  int difficultyLevel;
@override final  int basePoints;
@override final  num? economicBenefit;
@override@JsonKey() final  int participantsNeeded;
@override@JsonKey() final  RequestStatus status;
@override final  DateTime? deadline;
@override final  DateTime publishedAt;
@override final  RequestCreator creator;
 final  List<Tag> _tags;
@override@JsonKey() List<Tag> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  int applicationsCount;

/// Create a copy of RequestSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestSummaryCopyWith<_RequestSummary> get copyWith => __$RequestSummaryCopyWithImpl<_RequestSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RequestSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.difficultyLevel, difficultyLevel) || other.difficultyLevel == difficultyLevel)&&(identical(other.basePoints, basePoints) || other.basePoints == basePoints)&&(identical(other.economicBenefit, economicBenefit) || other.economicBenefit == economicBenefit)&&(identical(other.participantsNeeded, participantsNeeded) || other.participantsNeeded == participantsNeeded)&&(identical(other.status, status) || other.status == status)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.creator, creator) || other.creator == creator)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.applicationsCount, applicationsCount) || other.applicationsCount == applicationsCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,description,difficultyLevel,basePoints,economicBenefit,participantsNeeded,status,deadline,publishedAt,creator,const DeepCollectionEquality().hash(_tags),applicationsCount);

@override
String toString() {
  return 'RequestSummary(id: $id, type: $type, title: $title, description: $description, difficultyLevel: $difficultyLevel, basePoints: $basePoints, economicBenefit: $economicBenefit, participantsNeeded: $participantsNeeded, status: $status, deadline: $deadline, publishedAt: $publishedAt, creator: $creator, tags: $tags, applicationsCount: $applicationsCount)';
}


}

/// @nodoc
abstract mixin class _$RequestSummaryCopyWith<$Res> implements $RequestSummaryCopyWith<$Res> {
  factory _$RequestSummaryCopyWith(_RequestSummary value, $Res Function(_RequestSummary) _then) = __$RequestSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, RequestType type, String title, String description, int difficultyLevel, int basePoints, num? economicBenefit, int participantsNeeded, RequestStatus status, DateTime? deadline, DateTime publishedAt, RequestCreator creator, List<Tag> tags, int applicationsCount
});


@override $RequestCreatorCopyWith<$Res> get creator;

}
/// @nodoc
class __$RequestSummaryCopyWithImpl<$Res>
    implements _$RequestSummaryCopyWith<$Res> {
  __$RequestSummaryCopyWithImpl(this._self, this._then);

  final _RequestSummary _self;
  final $Res Function(_RequestSummary) _then;

/// Create a copy of RequestSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? description = null,Object? difficultyLevel = null,Object? basePoints = null,Object? economicBenefit = freezed,Object? participantsNeeded = null,Object? status = null,Object? deadline = freezed,Object? publishedAt = null,Object? creator = null,Object? tags = null,Object? applicationsCount = null,}) {
  return _then(_RequestSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RequestType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,difficultyLevel: null == difficultyLevel ? _self.difficultyLevel : difficultyLevel // ignore: cast_nullable_to_non_nullable
as int,basePoints: null == basePoints ? _self.basePoints : basePoints // ignore: cast_nullable_to_non_nullable
as int,economicBenefit: freezed == economicBenefit ? _self.economicBenefit : economicBenefit // ignore: cast_nullable_to_non_nullable
as num?,participantsNeeded: null == participantsNeeded ? _self.participantsNeeded : participantsNeeded // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RequestStatus,deadline: freezed == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime?,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,creator: null == creator ? _self.creator : creator // ignore: cast_nullable_to_non_nullable
as RequestCreator,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<Tag>,applicationsCount: null == applicationsCount ? _self.applicationsCount : applicationsCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of RequestSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequestCreatorCopyWith<$Res> get creator {
  
  return $RequestCreatorCopyWith<$Res>(_self.creator, (value) {
    return _then(_self.copyWith(creator: value));
  });
}
}

// dart format on
