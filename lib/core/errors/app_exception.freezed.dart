// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppException {
  String get message;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppExceptionCopyWith<AppException> get copyWith =>
      _$AppExceptionCopyWithImpl<AppException>(
          this as AppException, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppException &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'AppException(message: $message)';
  }
}

/// @nodoc
abstract mixin class $AppExceptionCopyWith<$Res> {
  factory $AppExceptionCopyWith(
          AppException value, $Res Function(AppException) _then) =
      _$AppExceptionCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$AppExceptionCopyWithImpl<$Res> implements $AppExceptionCopyWith<$Res> {
  _$AppExceptionCopyWithImpl(this._self, this._then);

  final AppException _self;
  final $Res Function(AppException) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_self.copyWith(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class NetworkException implements AppException {
  const NetworkException(
      {required this.message, this.statusCode, this.endpoint});

  @override
  final String message;
// 開発者向けメッセージ
  final int? statusCode;
// HTTPステータスコード（404、500など）
  final String? endpoint;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NetworkExceptionCopyWith<NetworkException> get copyWith =>
      _$NetworkExceptionCopyWithImpl<NetworkException>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NetworkException &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.endpoint, endpoint) ||
                other.endpoint == endpoint));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode, endpoint);

  @override
  String toString() {
    return 'AppException.network(message: $message, statusCode: $statusCode, endpoint: $endpoint)';
  }
}

/// @nodoc
abstract mixin class $NetworkExceptionCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory $NetworkExceptionCopyWith(
          NetworkException value, $Res Function(NetworkException) _then) =
      _$NetworkExceptionCopyWithImpl;
  @override
  @useResult
  $Res call({String message, int? statusCode, String? endpoint});
}

/// @nodoc
class _$NetworkExceptionCopyWithImpl<$Res>
    implements $NetworkExceptionCopyWith<$Res> {
  _$NetworkExceptionCopyWithImpl(this._self, this._then);

  final NetworkException _self;
  final $Res Function(NetworkException) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? statusCode = freezed,
    Object? endpoint = freezed,
  }) {
    return _then(NetworkException(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: freezed == statusCode
          ? _self.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      endpoint: freezed == endpoint
          ? _self.endpoint
          : endpoint // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class AuthException implements AppException {
  const AuthException(
      {required this.message, this.type = AuthErrorType.unknown});

  @override
  final String message;
  @JsonKey()
  final AuthErrorType type;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthExceptionCopyWith<AuthException> get copyWith =>
      _$AuthExceptionCopyWithImpl<AuthException>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthException &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, type);

  @override
  String toString() {
    return 'AppException.auth(message: $message, type: $type)';
  }
}

/// @nodoc
abstract mixin class $AuthExceptionCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory $AuthExceptionCopyWith(
          AuthException value, $Res Function(AuthException) _then) =
      _$AuthExceptionCopyWithImpl;
  @override
  @useResult
  $Res call({String message, AuthErrorType type});
}

/// @nodoc
class _$AuthExceptionCopyWithImpl<$Res>
    implements $AuthExceptionCopyWith<$Res> {
  _$AuthExceptionCopyWithImpl(this._self, this._then);

  final AuthException _self;
  final $Res Function(AuthException) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? type = null,
  }) {
    return _then(AuthException(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as AuthErrorType,
    ));
  }
}

/// @nodoc

class ValidationException implements AppException {
  const ValidationException(
      {required this.message, required this.field, this.value});

  @override
  final String message;
  final String field;
// エラーが発生したフィールド名
  final dynamic value;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ValidationExceptionCopyWith<ValidationException> get copyWith =>
      _$ValidationExceptionCopyWithImpl<ValidationException>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ValidationException &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.field, field) || other.field == field) &&
            const DeepCollectionEquality().equals(other.value, value));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, message, field, const DeepCollectionEquality().hash(value));

  @override
  String toString() {
    return 'AppException.validation(message: $message, field: $field, value: $value)';
  }
}

/// @nodoc
abstract mixin class $ValidationExceptionCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory $ValidationExceptionCopyWith(
          ValidationException value, $Res Function(ValidationException) _then) =
      _$ValidationExceptionCopyWithImpl;
  @override
  @useResult
  $Res call({String message, String field, dynamic value});
}

/// @nodoc
class _$ValidationExceptionCopyWithImpl<$Res>
    implements $ValidationExceptionCopyWith<$Res> {
  _$ValidationExceptionCopyWithImpl(this._self, this._then);

  final ValidationException _self;
  final $Res Function(ValidationException) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? field = null,
    Object? value = freezed,
  }) {
    return _then(ValidationException(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      field: null == field
          ? _self.field
          : field // ignore: cast_nullable_to_non_nullable
              as String,
      value: freezed == value
          ? _self.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ));
  }
}

/// @nodoc

class BusinessException implements AppException {
  const BusinessException(
      {required this.message,
      required this.code,
      final Map<String, dynamic>? details})
      : _details = details;

  @override
  final String message;
  final String code;
// エラーコード（例：INSUFFICIENT_STOCK）
  final Map<String, dynamic>? _details;
// エラーコード（例：INSUFFICIENT_STOCK）
  Map<String, dynamic>? get details {
    final value = _details;
    if (value == null) return null;
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BusinessExceptionCopyWith<BusinessException> get copyWith =>
      _$BusinessExceptionCopyWithImpl<BusinessException>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BusinessException &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.code, code) || other.code == code) &&
            const DeepCollectionEquality().equals(other._details, _details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, code,
      const DeepCollectionEquality().hash(_details));

  @override
  String toString() {
    return 'AppException.business(message: $message, code: $code, details: $details)';
  }
}

/// @nodoc
abstract mixin class $BusinessExceptionCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory $BusinessExceptionCopyWith(
          BusinessException value, $Res Function(BusinessException) _then) =
      _$BusinessExceptionCopyWithImpl;
  @override
  @useResult
  $Res call({String message, String code, Map<String, dynamic>? details});
}

/// @nodoc
class _$BusinessExceptionCopyWithImpl<$Res>
    implements $BusinessExceptionCopyWith<$Res> {
  _$BusinessExceptionCopyWithImpl(this._self, this._then);

  final BusinessException _self;
  final $Res Function(BusinessException) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? code = null,
    Object? details = freezed,
  }) {
    return _then(BusinessException(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _self.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _self._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc

class SystemException implements AppException {
  const SystemException(
      {required this.message, this.originalError, this.stackTrace});

  @override
  final String message;
  final Object? originalError;
// 元の例外オブジェクト
  final StackTrace? stackTrace;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SystemExceptionCopyWith<SystemException> get copyWith =>
      _$SystemExceptionCopyWithImpl<SystemException>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SystemException &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other.originalError, originalError) &&
            (identical(other.stackTrace, stackTrace) ||
                other.stackTrace == stackTrace));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message,
      const DeepCollectionEquality().hash(originalError), stackTrace);

  @override
  String toString() {
    return 'AppException.system(message: $message, originalError: $originalError, stackTrace: $stackTrace)';
  }
}

/// @nodoc
abstract mixin class $SystemExceptionCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory $SystemExceptionCopyWith(
          SystemException value, $Res Function(SystemException) _then) =
      _$SystemExceptionCopyWithImpl;
  @override
  @useResult
  $Res call({String message, Object? originalError, StackTrace? stackTrace});
}

/// @nodoc
class _$SystemExceptionCopyWithImpl<$Res>
    implements $SystemExceptionCopyWith<$Res> {
  _$SystemExceptionCopyWithImpl(this._self, this._then);

  final SystemException _self;
  final $Res Function(SystemException) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? originalError = freezed,
    Object? stackTrace = freezed,
  }) {
    return _then(SystemException(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      originalError:
          freezed == originalError ? _self.originalError : originalError,
      stackTrace: freezed == stackTrace
          ? _self.stackTrace
          : stackTrace // ignore: cast_nullable_to_non_nullable
              as StackTrace?,
    ));
  }
}

/// @nodoc

class DataException implements AppException {
  const DataException(
      {required this.message,
      this.type = DataErrorType.parseError,
      this.originalData});

  @override
  final String message;
  @JsonKey()
  final DataErrorType type;
  final Object? originalData;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DataExceptionCopyWith<DataException> get copyWith =>
      _$DataExceptionCopyWithImpl<DataException>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DataException &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other.originalData, originalData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, type,
      const DeepCollectionEquality().hash(originalData));

  @override
  String toString() {
    return 'AppException.data(message: $message, type: $type, originalData: $originalData)';
  }
}

/// @nodoc
abstract mixin class $DataExceptionCopyWith<$Res>
    implements $AppExceptionCopyWith<$Res> {
  factory $DataExceptionCopyWith(
          DataException value, $Res Function(DataException) _then) =
      _$DataExceptionCopyWithImpl;
  @override
  @useResult
  $Res call({String message, DataErrorType type, Object? originalData});
}

/// @nodoc
class _$DataExceptionCopyWithImpl<$Res>
    implements $DataExceptionCopyWith<$Res> {
  _$DataExceptionCopyWithImpl(this._self, this._then);

  final DataException _self;
  final $Res Function(DataException) _then;

  /// Create a copy of AppException
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
    Object? type = null,
    Object? originalData = freezed,
  }) {
    return _then(DataException(
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as DataErrorType,
      originalData: freezed == originalData ? _self.originalData : originalData,
    ));
  }
}

// dart format on
