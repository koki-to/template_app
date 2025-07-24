// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Post {
  int get userId;
  int get id;
  String get title;
  String get body;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostCopyWith<Post> get copyWith =>
      _$PostCopyWithImpl<Post>(this as Post, _$identity);

  /// Serializes this Post to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Post &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, id, title, body);

  @override
  String toString() {
    return 'Post(userId: $userId, id: $id, title: $title, body: $body)';
  }
}

/// @nodoc
abstract mixin class $PostCopyWith<$Res> {
  factory $PostCopyWith(Post value, $Res Function(Post) _then) =
      _$PostCopyWithImpl;
  @useResult
  $Res call({int userId, int id, String title, String body});
}

/// @nodoc
class _$PostCopyWithImpl<$Res> implements $PostCopyWith<$Res> {
  _$PostCopyWithImpl(this._self, this._then);

  final Post _self;
  final $Res Function(Post) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? id = null,
    Object? title = null,
    Object? body = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Post implements Post {
  const _Post(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});
  factory _Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  @override
  final int userId;
  @override
  final int id;
  @override
  final String title;
  @override
  final String body;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostCopyWith<_Post> get copyWith =>
      __$PostCopyWithImpl<_Post>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PostToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Post &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, id, title, body);

  @override
  String toString() {
    return 'Post(userId: $userId, id: $id, title: $title, body: $body)';
  }
}

/// @nodoc
abstract mixin class _$PostCopyWith<$Res> implements $PostCopyWith<$Res> {
  factory _$PostCopyWith(_Post value, $Res Function(_Post) _then) =
      __$PostCopyWithImpl;
  @override
  @useResult
  $Res call({int userId, int id, String title, String body});
}

/// @nodoc
class __$PostCopyWithImpl<$Res> implements _$PostCopyWith<$Res> {
  __$PostCopyWithImpl(this._self, this._then);

  final _Post _self;
  final $Res Function(_Post) _then;

  /// Create a copy of Post
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? id = null,
    Object? title = null,
    Object? body = null,
  }) {
    return _then(_Post(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$PostList {
  List<Post> get posts; // 投稿リスト
  int get totalCount; // 総投稿数
  bool get hasMore; // 追加データの有無
  int get currentPage;

  /// Create a copy of PostList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostListCopyWith<PostList> get copyWith =>
      _$PostListCopyWithImpl<PostList>(this as PostList, _$identity);

  /// Serializes this PostList to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostList &&
            const DeepCollectionEquality().equals(other.posts, posts) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(posts),
      totalCount,
      hasMore,
      currentPage);

  @override
  String toString() {
    return 'PostList(posts: $posts, totalCount: $totalCount, hasMore: $hasMore, currentPage: $currentPage)';
  }
}

/// @nodoc
abstract mixin class $PostListCopyWith<$Res> {
  factory $PostListCopyWith(PostList value, $Res Function(PostList) _then) =
      _$PostListCopyWithImpl;
  @useResult
  $Res call({List<Post> posts, int totalCount, bool hasMore, int currentPage});
}

/// @nodoc
class _$PostListCopyWithImpl<$Res> implements $PostListCopyWith<$Res> {
  _$PostListCopyWithImpl(this._self, this._then);

  final PostList _self;
  final $Res Function(PostList) _then;

  /// Create a copy of PostList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? totalCount = null,
    Object? hasMore = null,
    Object? currentPage = null,
  }) {
    return _then(_self.copyWith(
      posts: null == posts
          ? _self.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _PostList implements PostList {
  const _PostList(
      {final List<Post> posts = const [],
      this.totalCount = 0,
      this.hasMore = false,
      this.currentPage = 1})
      : _posts = posts;
  factory _PostList.fromJson(Map<String, dynamic> json) =>
      _$PostListFromJson(json);

  final List<Post> _posts;
  @override
  @JsonKey()
  List<Post> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

// 投稿リスト
  @override
  @JsonKey()
  final int totalCount;
// 総投稿数
  @override
  @JsonKey()
  final bool hasMore;
// 追加データの有無
  @override
  @JsonKey()
  final int currentPage;

  /// Create a copy of PostList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostListCopyWith<_PostList> get copyWith =>
      __$PostListCopyWithImpl<_PostList>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$PostListToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostList &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.totalCount, totalCount) ||
                other.totalCount == totalCount) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_posts),
      totalCount,
      hasMore,
      currentPage);

  @override
  String toString() {
    return 'PostList(posts: $posts, totalCount: $totalCount, hasMore: $hasMore, currentPage: $currentPage)';
  }
}

/// @nodoc
abstract mixin class _$PostListCopyWith<$Res>
    implements $PostListCopyWith<$Res> {
  factory _$PostListCopyWith(_PostList value, $Res Function(_PostList) _then) =
      __$PostListCopyWithImpl;
  @override
  @useResult
  $Res call({List<Post> posts, int totalCount, bool hasMore, int currentPage});
}

/// @nodoc
class __$PostListCopyWithImpl<$Res> implements _$PostListCopyWith<$Res> {
  __$PostListCopyWithImpl(this._self, this._then);

  final _PostList _self;
  final $Res Function(_PostList) _then;

  /// Create a copy of PostList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? posts = null,
    Object? totalCount = null,
    Object? hasMore = null,
    Object? currentPage = null,
  }) {
    return _then(_PostList(
      posts: null == posts
          ? _self._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      totalCount: null == totalCount
          ? _self.totalCount
          : totalCount // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _self.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
mixin _$CreatePostRequest {
  int get userId;
  String get title;
  String get body;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreatePostRequestCopyWith<CreatePostRequest> get copyWith =>
      _$CreatePostRequestCopyWithImpl<CreatePostRequest>(
          this as CreatePostRequest, _$identity);

  /// Serializes this CreatePostRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreatePostRequest &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, title, body);

  @override
  String toString() {
    return 'CreatePostRequest(userId: $userId, title: $title, body: $body)';
  }
}

/// @nodoc
abstract mixin class $CreatePostRequestCopyWith<$Res> {
  factory $CreatePostRequestCopyWith(
          CreatePostRequest value, $Res Function(CreatePostRequest) _then) =
      _$CreatePostRequestCopyWithImpl;
  @useResult
  $Res call({int userId, String title, String body});
}

/// @nodoc
class _$CreatePostRequestCopyWithImpl<$Res>
    implements $CreatePostRequestCopyWith<$Res> {
  _$CreatePostRequestCopyWithImpl(this._self, this._then);

  final CreatePostRequest _self;
  final $Res Function(CreatePostRequest) _then;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? title = null,
    Object? body = null,
  }) {
    return _then(_self.copyWith(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _CreatePostRequest implements CreatePostRequest {
  const _CreatePostRequest(
      {required this.userId, required this.title, required this.body});
  factory _CreatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePostRequestFromJson(json);

  @override
  final int userId;
  @override
  final String title;
  @override
  final String body;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$CreatePostRequestCopyWith<_CreatePostRequest> get copyWith =>
      __$CreatePostRequestCopyWithImpl<_CreatePostRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$CreatePostRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _CreatePostRequest &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, title, body);

  @override
  String toString() {
    return 'CreatePostRequest(userId: $userId, title: $title, body: $body)';
  }
}

/// @nodoc
abstract mixin class _$CreatePostRequestCopyWith<$Res>
    implements $CreatePostRequestCopyWith<$Res> {
  factory _$CreatePostRequestCopyWith(
          _CreatePostRequest value, $Res Function(_CreatePostRequest) _then) =
      __$CreatePostRequestCopyWithImpl;
  @override
  @useResult
  $Res call({int userId, String title, String body});
}

/// @nodoc
class __$CreatePostRequestCopyWithImpl<$Res>
    implements _$CreatePostRequestCopyWith<$Res> {
  __$CreatePostRequestCopyWithImpl(this._self, this._then);

  final _CreatePostRequest _self;
  final $Res Function(_CreatePostRequest) _then;

  /// Create a copy of CreatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? title = null,
    Object? body = null,
  }) {
    return _then(_CreatePostRequest(
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$UpdatePostRequest {
  int? get userId; // null の場合は更新しない
  String? get title; // null の場合は更新しない
  String? get body;

  /// Create a copy of UpdatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdatePostRequestCopyWith<UpdatePostRequest> get copyWith =>
      _$UpdatePostRequestCopyWithImpl<UpdatePostRequest>(
          this as UpdatePostRequest, _$identity);

  /// Serializes this UpdatePostRequest to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdatePostRequest &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, title, body);

  @override
  String toString() {
    return 'UpdatePostRequest(userId: $userId, title: $title, body: $body)';
  }
}

/// @nodoc
abstract mixin class $UpdatePostRequestCopyWith<$Res> {
  factory $UpdatePostRequestCopyWith(
          UpdatePostRequest value, $Res Function(UpdatePostRequest) _then) =
      _$UpdatePostRequestCopyWithImpl;
  @useResult
  $Res call({int? userId, String? title, String? body});
}

/// @nodoc
class _$UpdatePostRequestCopyWithImpl<$Res>
    implements $UpdatePostRequestCopyWith<$Res> {
  _$UpdatePostRequestCopyWithImpl(this._self, this._then);

  final UpdatePostRequest _self;
  final $Res Function(UpdatePostRequest) _then;

  /// Create a copy of UpdatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = freezed,
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_self.copyWith(
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UpdatePostRequest implements UpdatePostRequest {
  const _UpdatePostRequest({this.userId, this.title, this.body});
  factory _UpdatePostRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePostRequestFromJson(json);

  @override
  final int? userId;
// null の場合は更新しない
  @override
  final String? title;
// null の場合は更新しない
  @override
  final String? body;

  /// Create a copy of UpdatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UpdatePostRequestCopyWith<_UpdatePostRequest> get copyWith =>
      __$UpdatePostRequestCopyWithImpl<_UpdatePostRequest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UpdatePostRequestToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UpdatePostRequest &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, userId, title, body);

  @override
  String toString() {
    return 'UpdatePostRequest(userId: $userId, title: $title, body: $body)';
  }
}

/// @nodoc
abstract mixin class _$UpdatePostRequestCopyWith<$Res>
    implements $UpdatePostRequestCopyWith<$Res> {
  factory _$UpdatePostRequestCopyWith(
          _UpdatePostRequest value, $Res Function(_UpdatePostRequest) _then) =
      __$UpdatePostRequestCopyWithImpl;
  @override
  @useResult
  $Res call({int? userId, String? title, String? body});
}

/// @nodoc
class __$UpdatePostRequestCopyWithImpl<$Res>
    implements _$UpdatePostRequestCopyWith<$Res> {
  __$UpdatePostRequestCopyWithImpl(this._self, this._then);

  final _UpdatePostRequest _self;
  final $Res Function(_UpdatePostRequest) _then;

  /// Create a copy of UpdatePostRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = freezed,
    Object? title = freezed,
    Object? body = freezed,
  }) {
    return _then(_UpdatePostRequest(
      userId: freezed == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      body: freezed == body
          ? _self.body
          : body // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
