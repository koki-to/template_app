// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_page_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostPageState {
// === データ状態 ===
  List<Post> get posts;
  bool get isLoading;
  bool get isRefreshing;
  AppException? get error; // === 検索機能 ===
  String get searchKeyword;
  List<Post> get searchResults;
  bool get isSearching;
  bool get showSearchResults; // === フィルタリング ===
  int? get selectedUserId;
  PostLengthCategory? get selectedCategory;
  SortType get sortType; // === UI状態 ===
  PostsViewMode get viewMode;
  bool get showFilters;
  bool get isSelectionMode;
  Set<int> get selectedPostIds; // === ページネーション ===
  int get currentPage;
  bool get hasMorePosts;
  bool get isLoadingMore; // === 統計・分析 ===
  PostsAnalytics? get analytics;
  bool get showAnalytics; // === 操作状態 ===
  Map<int, bool> get deletingPosts; // 削除中の投稿ID
  int? get editingPostId; // 編集中の投稿ID
// === エラー詳細 ===
  bool get showErrorDetails; // === 最終更新時刻 ===
  DateTime? get lastUpdated;

  /// Create a copy of PostPageState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PostPageStateCopyWith<PostPageState> get copyWith =>
      _$PostPageStateCopyWithImpl<PostPageState>(
          this as PostPageState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PostPageState &&
            const DeepCollectionEquality().equals(other.posts, posts) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchKeyword, searchKeyword) ||
                other.searchKeyword == searchKeyword) &&
            const DeepCollectionEquality()
                .equals(other.searchResults, searchResults) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.showSearchResults, showSearchResults) ||
                other.showSearchResults == showSearchResults) &&
            (identical(other.selectedUserId, selectedUserId) ||
                other.selectedUserId == selectedUserId) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode) &&
            (identical(other.showFilters, showFilters) ||
                other.showFilters == showFilters) &&
            (identical(other.isSelectionMode, isSelectionMode) ||
                other.isSelectionMode == isSelectionMode) &&
            const DeepCollectionEquality()
                .equals(other.selectedPostIds, selectedPostIds) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasMorePosts, hasMorePosts) ||
                other.hasMorePosts == hasMorePosts) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.analytics, analytics) ||
                other.analytics == analytics) &&
            (identical(other.showAnalytics, showAnalytics) ||
                other.showAnalytics == showAnalytics) &&
            const DeepCollectionEquality()
                .equals(other.deletingPosts, deletingPosts) &&
            (identical(other.editingPostId, editingPostId) ||
                other.editingPostId == editingPostId) &&
            (identical(other.showErrorDetails, showErrorDetails) ||
                other.showErrorDetails == showErrorDetails) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(posts),
        isLoading,
        isRefreshing,
        error,
        searchKeyword,
        const DeepCollectionEquality().hash(searchResults),
        isSearching,
        showSearchResults,
        selectedUserId,
        selectedCategory,
        sortType,
        viewMode,
        showFilters,
        isSelectionMode,
        const DeepCollectionEquality().hash(selectedPostIds),
        currentPage,
        hasMorePosts,
        isLoadingMore,
        analytics,
        showAnalytics,
        const DeepCollectionEquality().hash(deletingPosts),
        editingPostId,
        showErrorDetails,
        lastUpdated
      ]);

  @override
  String toString() {
    return 'PostPageState(posts: $posts, isLoading: $isLoading, isRefreshing: $isRefreshing, error: $error, searchKeyword: $searchKeyword, searchResults: $searchResults, isSearching: $isSearching, showSearchResults: $showSearchResults, selectedUserId: $selectedUserId, selectedCategory: $selectedCategory, sortType: $sortType, viewMode: $viewMode, showFilters: $showFilters, isSelectionMode: $isSelectionMode, selectedPostIds: $selectedPostIds, currentPage: $currentPage, hasMorePosts: $hasMorePosts, isLoadingMore: $isLoadingMore, analytics: $analytics, showAnalytics: $showAnalytics, deletingPosts: $deletingPosts, editingPostId: $editingPostId, showErrorDetails: $showErrorDetails, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class $PostPageStateCopyWith<$Res> {
  factory $PostPageStateCopyWith(
          PostPageState value, $Res Function(PostPageState) _then) =
      _$PostPageStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Post> posts,
      bool isLoading,
      bool isRefreshing,
      AppException? error,
      String searchKeyword,
      List<Post> searchResults,
      bool isSearching,
      bool showSearchResults,
      int? selectedUserId,
      PostLengthCategory? selectedCategory,
      SortType sortType,
      PostsViewMode viewMode,
      bool showFilters,
      bool isSelectionMode,
      Set<int> selectedPostIds,
      int currentPage,
      bool hasMorePosts,
      bool isLoadingMore,
      PostsAnalytics? analytics,
      bool showAnalytics,
      Map<int, bool> deletingPosts,
      int? editingPostId,
      bool showErrorDetails,
      DateTime? lastUpdated});

  $AppExceptionCopyWith<$Res>? get error;
}

/// @nodoc
class _$PostPageStateCopyWithImpl<$Res>
    implements $PostPageStateCopyWith<$Res> {
  _$PostPageStateCopyWithImpl(this._self, this._then);

  final PostPageState _self;
  final $Res Function(PostPageState) _then;

  /// Create a copy of PostPageState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? posts = null,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? error = freezed,
    Object? searchKeyword = null,
    Object? searchResults = null,
    Object? isSearching = null,
    Object? showSearchResults = null,
    Object? selectedUserId = freezed,
    Object? selectedCategory = freezed,
    Object? sortType = null,
    Object? viewMode = null,
    Object? showFilters = null,
    Object? isSelectionMode = null,
    Object? selectedPostIds = null,
    Object? currentPage = null,
    Object? hasMorePosts = null,
    Object? isLoadingMore = null,
    Object? analytics = freezed,
    Object? showAnalytics = null,
    Object? deletingPosts = null,
    Object? editingPostId = freezed,
    Object? showErrorDetails = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_self.copyWith(
      posts: null == posts
          ? _self.posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _self.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as AppException?,
      searchKeyword: null == searchKeyword
          ? _self.searchKeyword
          : searchKeyword // ignore: cast_nullable_to_non_nullable
              as String,
      searchResults: null == searchResults
          ? _self.searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      isSearching: null == isSearching
          ? _self.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      showSearchResults: null == showSearchResults
          ? _self.showSearchResults
          : showSearchResults // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedUserId: freezed == selectedUserId
          ? _self.selectedUserId
          : selectedUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCategory: freezed == selectedCategory
          ? _self.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as PostLengthCategory?,
      sortType: null == sortType
          ? _self.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as SortType,
      viewMode: null == viewMode
          ? _self.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as PostsViewMode,
      showFilters: null == showFilters
          ? _self.showFilters
          : showFilters // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelectionMode: null == isSelectionMode
          ? _self.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedPostIds: null == selectedPostIds
          ? _self.selectedPostIds
          : selectedPostIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMorePosts: null == hasMorePosts
          ? _self.hasMorePosts
          : hasMorePosts // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      analytics: freezed == analytics
          ? _self.analytics
          : analytics // ignore: cast_nullable_to_non_nullable
              as PostsAnalytics?,
      showAnalytics: null == showAnalytics
          ? _self.showAnalytics
          : showAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      deletingPosts: null == deletingPosts
          ? _self.deletingPosts
          : deletingPosts // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      editingPostId: freezed == editingPostId
          ? _self.editingPostId
          : editingPostId // ignore: cast_nullable_to_non_nullable
              as int?,
      showErrorDetails: null == showErrorDetails
          ? _self.showErrorDetails
          : showErrorDetails // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUpdated: freezed == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of PostPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppExceptionCopyWith<$Res>? get error {
    if (_self.error == null) {
      return null;
    }

    return $AppExceptionCopyWith<$Res>(_self.error!, (value) {
      return _then(_self.copyWith(error: value));
    });
  }
}

/// @nodoc

class _PostPageState implements PostPageState {
  const _PostPageState(
      {final List<Post> posts = const [],
      this.isLoading = false,
      this.isRefreshing = false,
      this.error,
      this.searchKeyword = '',
      final List<Post> searchResults = const [],
      this.isSearching = false,
      this.showSearchResults = false,
      this.selectedUserId,
      this.selectedCategory,
      this.sortType = SortType.newest,
      this.viewMode = PostsViewMode.list,
      this.showFilters = false,
      this.isSelectionMode = false,
      final Set<int> selectedPostIds = const {},
      this.currentPage = 0,
      this.hasMorePosts = false,
      this.isLoadingMore = false,
      this.analytics,
      this.showAnalytics = false,
      final Map<int, bool> deletingPosts = const {},
      this.editingPostId,
      this.showErrorDetails = false,
      this.lastUpdated})
      : _posts = posts,
        _searchResults = searchResults,
        _selectedPostIds = selectedPostIds,
        _deletingPosts = deletingPosts;

// === データ状態 ===
  final List<Post> _posts;
// === データ状態 ===
  @override
  @JsonKey()
  List<Post> get posts {
    if (_posts is EqualUnmodifiableListView) return _posts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_posts);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  final AppException? error;
// === 検索機能 ===
  @override
  @JsonKey()
  final String searchKeyword;
  final List<Post> _searchResults;
  @override
  @JsonKey()
  List<Post> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  @override
  @JsonKey()
  final bool isSearching;
  @override
  @JsonKey()
  final bool showSearchResults;
// === フィルタリング ===
  @override
  final int? selectedUserId;
  @override
  final PostLengthCategory? selectedCategory;
  @override
  @JsonKey()
  final SortType sortType;
// === UI状態 ===
  @override
  @JsonKey()
  final PostsViewMode viewMode;
  @override
  @JsonKey()
  final bool showFilters;
  @override
  @JsonKey()
  final bool isSelectionMode;
  final Set<int> _selectedPostIds;
  @override
  @JsonKey()
  Set<int> get selectedPostIds {
    if (_selectedPostIds is EqualUnmodifiableSetView) return _selectedPostIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedPostIds);
  }

// === ページネーション ===
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool hasMorePosts;
  @override
  @JsonKey()
  final bool isLoadingMore;
// === 統計・分析 ===
  @override
  final PostsAnalytics? analytics;
  @override
  @JsonKey()
  final bool showAnalytics;
// === 操作状態 ===
  final Map<int, bool> _deletingPosts;
// === 操作状態 ===
  @override
  @JsonKey()
  Map<int, bool> get deletingPosts {
    if (_deletingPosts is EqualUnmodifiableMapView) return _deletingPosts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_deletingPosts);
  }

// 削除中の投稿ID
  @override
  final int? editingPostId;
// 編集中の投稿ID
// === エラー詳細 ===
  @override
  @JsonKey()
  final bool showErrorDetails;
// === 最終更新時刻 ===
  @override
  final DateTime? lastUpdated;

  /// Create a copy of PostPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PostPageStateCopyWith<_PostPageState> get copyWith =>
      __$PostPageStateCopyWithImpl<_PostPageState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _PostPageState &&
            const DeepCollectionEquality().equals(other._posts, _posts) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.searchKeyword, searchKeyword) ||
                other.searchKeyword == searchKeyword) &&
            const DeepCollectionEquality()
                .equals(other._searchResults, _searchResults) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.showSearchResults, showSearchResults) ||
                other.showSearchResults == showSearchResults) &&
            (identical(other.selectedUserId, selectedUserId) ||
                other.selectedUserId == selectedUserId) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.sortType, sortType) ||
                other.sortType == sortType) &&
            (identical(other.viewMode, viewMode) ||
                other.viewMode == viewMode) &&
            (identical(other.showFilters, showFilters) ||
                other.showFilters == showFilters) &&
            (identical(other.isSelectionMode, isSelectionMode) ||
                other.isSelectionMode == isSelectionMode) &&
            const DeepCollectionEquality()
                .equals(other._selectedPostIds, _selectedPostIds) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.hasMorePosts, hasMorePosts) ||
                other.hasMorePosts == hasMorePosts) &&
            (identical(other.isLoadingMore, isLoadingMore) ||
                other.isLoadingMore == isLoadingMore) &&
            (identical(other.analytics, analytics) ||
                other.analytics == analytics) &&
            (identical(other.showAnalytics, showAnalytics) ||
                other.showAnalytics == showAnalytics) &&
            const DeepCollectionEquality()
                .equals(other._deletingPosts, _deletingPosts) &&
            (identical(other.editingPostId, editingPostId) ||
                other.editingPostId == editingPostId) &&
            (identical(other.showErrorDetails, showErrorDetails) ||
                other.showErrorDetails == showErrorDetails) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_posts),
        isLoading,
        isRefreshing,
        error,
        searchKeyword,
        const DeepCollectionEquality().hash(_searchResults),
        isSearching,
        showSearchResults,
        selectedUserId,
        selectedCategory,
        sortType,
        viewMode,
        showFilters,
        isSelectionMode,
        const DeepCollectionEquality().hash(_selectedPostIds),
        currentPage,
        hasMorePosts,
        isLoadingMore,
        analytics,
        showAnalytics,
        const DeepCollectionEquality().hash(_deletingPosts),
        editingPostId,
        showErrorDetails,
        lastUpdated
      ]);

  @override
  String toString() {
    return 'PostPageState(posts: $posts, isLoading: $isLoading, isRefreshing: $isRefreshing, error: $error, searchKeyword: $searchKeyword, searchResults: $searchResults, isSearching: $isSearching, showSearchResults: $showSearchResults, selectedUserId: $selectedUserId, selectedCategory: $selectedCategory, sortType: $sortType, viewMode: $viewMode, showFilters: $showFilters, isSelectionMode: $isSelectionMode, selectedPostIds: $selectedPostIds, currentPage: $currentPage, hasMorePosts: $hasMorePosts, isLoadingMore: $isLoadingMore, analytics: $analytics, showAnalytics: $showAnalytics, deletingPosts: $deletingPosts, editingPostId: $editingPostId, showErrorDetails: $showErrorDetails, lastUpdated: $lastUpdated)';
  }
}

/// @nodoc
abstract mixin class _$PostPageStateCopyWith<$Res>
    implements $PostPageStateCopyWith<$Res> {
  factory _$PostPageStateCopyWith(
          _PostPageState value, $Res Function(_PostPageState) _then) =
      __$PostPageStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Post> posts,
      bool isLoading,
      bool isRefreshing,
      AppException? error,
      String searchKeyword,
      List<Post> searchResults,
      bool isSearching,
      bool showSearchResults,
      int? selectedUserId,
      PostLengthCategory? selectedCategory,
      SortType sortType,
      PostsViewMode viewMode,
      bool showFilters,
      bool isSelectionMode,
      Set<int> selectedPostIds,
      int currentPage,
      bool hasMorePosts,
      bool isLoadingMore,
      PostsAnalytics? analytics,
      bool showAnalytics,
      Map<int, bool> deletingPosts,
      int? editingPostId,
      bool showErrorDetails,
      DateTime? lastUpdated});

  @override
  $AppExceptionCopyWith<$Res>? get error;
}

/// @nodoc
class __$PostPageStateCopyWithImpl<$Res>
    implements _$PostPageStateCopyWith<$Res> {
  __$PostPageStateCopyWithImpl(this._self, this._then);

  final _PostPageState _self;
  final $Res Function(_PostPageState) _then;

  /// Create a copy of PostPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? posts = null,
    Object? isLoading = null,
    Object? isRefreshing = null,
    Object? error = freezed,
    Object? searchKeyword = null,
    Object? searchResults = null,
    Object? isSearching = null,
    Object? showSearchResults = null,
    Object? selectedUserId = freezed,
    Object? selectedCategory = freezed,
    Object? sortType = null,
    Object? viewMode = null,
    Object? showFilters = null,
    Object? isSelectionMode = null,
    Object? selectedPostIds = null,
    Object? currentPage = null,
    Object? hasMorePosts = null,
    Object? isLoadingMore = null,
    Object? analytics = freezed,
    Object? showAnalytics = null,
    Object? deletingPosts = null,
    Object? editingPostId = freezed,
    Object? showErrorDetails = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_PostPageState(
      posts: null == posts
          ? _self._posts
          : posts // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _self.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as AppException?,
      searchKeyword: null == searchKeyword
          ? _self.searchKeyword
          : searchKeyword // ignore: cast_nullable_to_non_nullable
              as String,
      searchResults: null == searchResults
          ? _self._searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<Post>,
      isSearching: null == isSearching
          ? _self.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      showSearchResults: null == showSearchResults
          ? _self.showSearchResults
          : showSearchResults // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedUserId: freezed == selectedUserId
          ? _self.selectedUserId
          : selectedUserId // ignore: cast_nullable_to_non_nullable
              as int?,
      selectedCategory: freezed == selectedCategory
          ? _self.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as PostLengthCategory?,
      sortType: null == sortType
          ? _self.sortType
          : sortType // ignore: cast_nullable_to_non_nullable
              as SortType,
      viewMode: null == viewMode
          ? _self.viewMode
          : viewMode // ignore: cast_nullable_to_non_nullable
              as PostsViewMode,
      showFilters: null == showFilters
          ? _self.showFilters
          : showFilters // ignore: cast_nullable_to_non_nullable
              as bool,
      isSelectionMode: null == isSelectionMode
          ? _self.isSelectionMode
          : isSelectionMode // ignore: cast_nullable_to_non_nullable
              as bool,
      selectedPostIds: null == selectedPostIds
          ? _self._selectedPostIds
          : selectedPostIds // ignore: cast_nullable_to_non_nullable
              as Set<int>,
      currentPage: null == currentPage
          ? _self.currentPage
          : currentPage // ignore: cast_nullable_to_non_nullable
              as int,
      hasMorePosts: null == hasMorePosts
          ? _self.hasMorePosts
          : hasMorePosts // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingMore: null == isLoadingMore
          ? _self.isLoadingMore
          : isLoadingMore // ignore: cast_nullable_to_non_nullable
              as bool,
      analytics: freezed == analytics
          ? _self.analytics
          : analytics // ignore: cast_nullable_to_non_nullable
              as PostsAnalytics?,
      showAnalytics: null == showAnalytics
          ? _self.showAnalytics
          : showAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      deletingPosts: null == deletingPosts
          ? _self._deletingPosts
          : deletingPosts // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      editingPostId: freezed == editingPostId
          ? _self.editingPostId
          : editingPostId // ignore: cast_nullable_to_non_nullable
              as int?,
      showErrorDetails: null == showErrorDetails
          ? _self.showErrorDetails
          : showErrorDetails // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUpdated: freezed == lastUpdated
          ? _self.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }

  /// Create a copy of PostPageState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppExceptionCopyWith<$Res>? get error {
    if (_self.error == null) {
      return null;
    }

    return $AppExceptionCopyWith<$Res>(_self.error!, (value) {
      return _then(_self.copyWith(error: value));
    });
  }
}

// dart format on
