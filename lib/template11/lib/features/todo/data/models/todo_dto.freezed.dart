// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoDto {
  String get id;
  String get title;
  String get description;
  bool get isCompleted;
  String get createdAt;
  String? get completedAt;
  String get priority;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TodoDtoCopyWith<TodoDto> get copyWith =>
      _$TodoDtoCopyWithImpl<TodoDto>(this as TodoDto, _$identity);

  /// Serializes this TodoDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TodoDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      isCompleted, createdAt, completedAt, priority);

  @override
  String toString() {
    return 'TodoDto(id: $id, title: $title, description: $description, isCompleted: $isCompleted, createdAt: $createdAt, completedAt: $completedAt, priority: $priority)';
  }
}

/// @nodoc
abstract mixin class $TodoDtoCopyWith<$Res> {
  factory $TodoDtoCopyWith(TodoDto value, $Res Function(TodoDto) _then) =
      _$TodoDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      bool isCompleted,
      String createdAt,
      String? completedAt,
      String priority});
}

/// @nodoc
class _$TodoDtoCopyWithImpl<$Res> implements $TodoDtoCopyWith<$Res> {
  _$TodoDtoCopyWithImpl(this._self, this._then);

  final TodoDto _self;
  final $Res Function(TodoDto) _then;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? isCompleted = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? priority = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TodoDto extends TodoDto {
  const _TodoDto(
      {required this.id,
      required this.title,
      required this.description,
      required this.isCompleted,
      required this.createdAt,
      this.completedAt,
      this.priority = 'medium'})
      : super._();
  factory _TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final bool isCompleted;
  @override
  final String createdAt;
  @override
  final String? completedAt;
  @override
  @JsonKey()
  final String priority;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TodoDtoCopyWith<_TodoDto> get copyWith =>
      __$TodoDtoCopyWithImpl<_TodoDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TodoDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodoDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, description,
      isCompleted, createdAt, completedAt, priority);

  @override
  String toString() {
    return 'TodoDto(id: $id, title: $title, description: $description, isCompleted: $isCompleted, createdAt: $createdAt, completedAt: $completedAt, priority: $priority)';
  }
}

/// @nodoc
abstract mixin class _$TodoDtoCopyWith<$Res> implements $TodoDtoCopyWith<$Res> {
  factory _$TodoDtoCopyWith(_TodoDto value, $Res Function(_TodoDto) _then) =
      __$TodoDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      bool isCompleted,
      String createdAt,
      String? completedAt,
      String priority});
}

/// @nodoc
class __$TodoDtoCopyWithImpl<$Res> implements _$TodoDtoCopyWith<$Res> {
  __$TodoDtoCopyWithImpl(this._self, this._then);

  final _TodoDto _self;
  final $Res Function(_TodoDto) _then;

  /// Create a copy of TodoDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? isCompleted = null,
    Object? createdAt = null,
    Object? completedAt = freezed,
    Object? priority = null,
  }) {
    return _then(_TodoDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _self.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _self.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
