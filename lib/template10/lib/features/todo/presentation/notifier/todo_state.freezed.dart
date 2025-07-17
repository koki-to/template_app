// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TodoState {
  List<Todo> get todos;
  List<Todo> get filteredTodos;
  bool get isLoading;
  bool get isCreating;
  bool get isUpdating;
  bool get isDeleting;
  TodoFilterSettings get filterSettings;
  List<String> get selectedTodoIds;
  Failure? get failure;
  TodoStatistics? get statistics;

  /// Create a copy of TodoState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TodoStateCopyWith<TodoState> get copyWith =>
      _$TodoStateCopyWithImpl<TodoState>(this as TodoState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TodoState &&
            const DeepCollectionEquality().equals(other.todos, todos) &&
            const DeepCollectionEquality()
                .equals(other.filteredTodos, filteredTodos) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.filterSettings, filterSettings) ||
                other.filterSettings == filterSettings) &&
            const DeepCollectionEquality()
                .equals(other.selectedTodoIds, selectedTodoIds) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.statistics, statistics) ||
                other.statistics == statistics));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(todos),
      const DeepCollectionEquality().hash(filteredTodos),
      isLoading,
      isCreating,
      isUpdating,
      isDeleting,
      filterSettings,
      const DeepCollectionEquality().hash(selectedTodoIds),
      failure,
      statistics);

  @override
  String toString() {
    return 'TodoState(todos: $todos, filteredTodos: $filteredTodos, isLoading: $isLoading, isCreating: $isCreating, isUpdating: $isUpdating, isDeleting: $isDeleting, filterSettings: $filterSettings, selectedTodoIds: $selectedTodoIds, failure: $failure, statistics: $statistics)';
  }
}

/// @nodoc
abstract mixin class $TodoStateCopyWith<$Res> {
  factory $TodoStateCopyWith(TodoState value, $Res Function(TodoState) _then) =
      _$TodoStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Todo> todos,
      List<Todo> filteredTodos,
      bool isLoading,
      bool isCreating,
      bool isUpdating,
      bool isDeleting,
      TodoFilterSettings filterSettings,
      List<String> selectedTodoIds,
      Failure? failure,
      TodoStatistics? statistics});
}

/// @nodoc
class _$TodoStateCopyWithImpl<$Res> implements $TodoStateCopyWith<$Res> {
  _$TodoStateCopyWithImpl(this._self, this._then);

  final TodoState _self;
  final $Res Function(TodoState) _then;

  /// Create a copy of TodoState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todos = null,
    Object? filteredTodos = null,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? isUpdating = null,
    Object? isDeleting = null,
    Object? filterSettings = null,
    Object? selectedTodoIds = null,
    Object? failure = freezed,
    Object? statistics = freezed,
  }) {
    return _then(_self.copyWith(
      todos: null == todos
          ? _self.todos
          : todos // ignore: cast_nullable_to_non_nullable
              as List<Todo>,
      filteredTodos: null == filteredTodos
          ? _self.filteredTodos
          : filteredTodos // ignore: cast_nullable_to_non_nullable
              as List<Todo>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _self.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _self.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _self.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      filterSettings: null == filterSettings
          ? _self.filterSettings
          : filterSettings // ignore: cast_nullable_to_non_nullable
              as TodoFilterSettings,
      selectedTodoIds: null == selectedTodoIds
          ? _self.selectedTodoIds
          : selectedTodoIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      failure: freezed == failure
          ? _self.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
      statistics: freezed == statistics
          ? _self.statistics
          : statistics // ignore: cast_nullable_to_non_nullable
              as TodoStatistics?,
    ));
  }
}

/// @nodoc

class _TodoState extends TodoState {
  const _TodoState(
      {final List<Todo> todos = const [],
      final List<Todo> filteredTodos = const [],
      this.isLoading = false,
      this.isCreating = false,
      this.isUpdating = false,
      this.isDeleting = false,
      this.filterSettings = const TodoFilterSettings(),
      final List<String> selectedTodoIds = const [],
      this.failure,
      this.statistics})
      : _todos = todos,
        _filteredTodos = filteredTodos,
        _selectedTodoIds = selectedTodoIds,
        super._();

  final List<Todo> _todos;
  @override
  @JsonKey()
  List<Todo> get todos {
    if (_todos is EqualUnmodifiableListView) return _todos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_todos);
  }

  final List<Todo> _filteredTodos;
  @override
  @JsonKey()
  List<Todo> get filteredTodos {
    if (_filteredTodos is EqualUnmodifiableListView) return _filteredTodos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_filteredTodos);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isCreating;
  @override
  @JsonKey()
  final bool isUpdating;
  @override
  @JsonKey()
  final bool isDeleting;
  @override
  @JsonKey()
  final TodoFilterSettings filterSettings;
  final List<String> _selectedTodoIds;
  @override
  @JsonKey()
  List<String> get selectedTodoIds {
    if (_selectedTodoIds is EqualUnmodifiableListView) return _selectedTodoIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedTodoIds);
  }

  @override
  final Failure? failure;
  @override
  final TodoStatistics? statistics;

  /// Create a copy of TodoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TodoStateCopyWith<_TodoState> get copyWith =>
      __$TodoStateCopyWithImpl<_TodoState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TodoState &&
            const DeepCollectionEquality().equals(other._todos, _todos) &&
            const DeepCollectionEquality()
                .equals(other._filteredTodos, _filteredTodos) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isCreating, isCreating) ||
                other.isCreating == isCreating) &&
            (identical(other.isUpdating, isUpdating) ||
                other.isUpdating == isUpdating) &&
            (identical(other.isDeleting, isDeleting) ||
                other.isDeleting == isDeleting) &&
            (identical(other.filterSettings, filterSettings) ||
                other.filterSettings == filterSettings) &&
            const DeepCollectionEquality()
                .equals(other._selectedTodoIds, _selectedTodoIds) &&
            (identical(other.failure, failure) || other.failure == failure) &&
            (identical(other.statistics, statistics) ||
                other.statistics == statistics));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_todos),
      const DeepCollectionEquality().hash(_filteredTodos),
      isLoading,
      isCreating,
      isUpdating,
      isDeleting,
      filterSettings,
      const DeepCollectionEquality().hash(_selectedTodoIds),
      failure,
      statistics);

  @override
  String toString() {
    return 'TodoState(todos: $todos, filteredTodos: $filteredTodos, isLoading: $isLoading, isCreating: $isCreating, isUpdating: $isUpdating, isDeleting: $isDeleting, filterSettings: $filterSettings, selectedTodoIds: $selectedTodoIds, failure: $failure, statistics: $statistics)';
  }
}

/// @nodoc
abstract mixin class _$TodoStateCopyWith<$Res>
    implements $TodoStateCopyWith<$Res> {
  factory _$TodoStateCopyWith(
          _TodoState value, $Res Function(_TodoState) _then) =
      __$TodoStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Todo> todos,
      List<Todo> filteredTodos,
      bool isLoading,
      bool isCreating,
      bool isUpdating,
      bool isDeleting,
      TodoFilterSettings filterSettings,
      List<String> selectedTodoIds,
      Failure? failure,
      TodoStatistics? statistics});
}

/// @nodoc
class __$TodoStateCopyWithImpl<$Res> implements _$TodoStateCopyWith<$Res> {
  __$TodoStateCopyWithImpl(this._self, this._then);

  final _TodoState _self;
  final $Res Function(_TodoState) _then;

  /// Create a copy of TodoState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? todos = null,
    Object? filteredTodos = null,
    Object? isLoading = null,
    Object? isCreating = null,
    Object? isUpdating = null,
    Object? isDeleting = null,
    Object? filterSettings = null,
    Object? selectedTodoIds = null,
    Object? failure = freezed,
    Object? statistics = freezed,
  }) {
    return _then(_TodoState(
      todos: null == todos
          ? _self._todos
          : todos // ignore: cast_nullable_to_non_nullable
              as List<Todo>,
      filteredTodos: null == filteredTodos
          ? _self._filteredTodos
          : filteredTodos // ignore: cast_nullable_to_non_nullable
              as List<Todo>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isCreating: null == isCreating
          ? _self.isCreating
          : isCreating // ignore: cast_nullable_to_non_nullable
              as bool,
      isUpdating: null == isUpdating
          ? _self.isUpdating
          : isUpdating // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleting: null == isDeleting
          ? _self.isDeleting
          : isDeleting // ignore: cast_nullable_to_non_nullable
              as bool,
      filterSettings: null == filterSettings
          ? _self.filterSettings
          : filterSettings // ignore: cast_nullable_to_non_nullable
              as TodoFilterSettings,
      selectedTodoIds: null == selectedTodoIds
          ? _self._selectedTodoIds
          : selectedTodoIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      failure: freezed == failure
          ? _self.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure?,
      statistics: freezed == statistics
          ? _self.statistics
          : statistics // ignore: cast_nullable_to_non_nullable
              as TodoStatistics?,
    ));
  }
}

// dart format on
