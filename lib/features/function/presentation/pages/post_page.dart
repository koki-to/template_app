// lib/presentation/screens/posts/posts_screen.dart
// 一画面一Notifier設計での改良版Posts画面

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/core/errors/app_exception.dart';
import 'package:template_app/features/function/data/models/post_model.dart';
import 'package:template_app/features/function/domain/service/post_service.dart';
import 'package:template_app/features/function/presentation/pages/post_page_notifier.dart';
import 'package:template_app/features/function/presentation/widgets/error_dialog.dart';

// ===============================
// 📱 PostsScreen：メイン画面
// ===============================

/// 一画面一Notifier設計でのPosts画面
///
/// 【設計上の改善点】
/// 1. 単一のNotifierですべての状態を管理
/// 2. Service層でビジネスロジックを分離
/// 3. 細かな状態管理で良好なUX提供
/// 4. エラーハンドリングの統一
class PostPage extends ConsumerStatefulWidget {
  const PostPage({super.key});

  @override
  ConsumerState<PostPage> createState() => _PostsScreenState();
}

class _PostsScreenState extends ConsumerState<PostPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 画面初期化
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postPageProvider.notifier).initialize();
    });

    // スクロール監視（無限スクロール）
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// スクロール監視（無限スクロール）
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(postPageProvider.notifier).loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(searchController: _searchController),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  /// メイン画面構築
  Widget _buildBody() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(postPageProvider);
        final notifier = ref.read(postPageProvider.notifier);

        return RefreshIndicator(
          onRefresh: notifier.refreshPosts,
          child: Column(
            children: [
              // フィルター表示
              if (state.showFilters) _buildFilters(),

              // 統計表示
              if (state.showAnalytics && state.analytics != null)
                _buildAnalyticsCard(state.analytics!),

              // 選択モード情報
              if (state.isSelectionMode) _buildSelectionModeBar(),

              // メインコンテンツ
              Expanded(child: _buildMainContent()),
            ],
          ),
        );
      },
    );
  }

  /// フィルター表示
  Widget _buildFilters() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(postPageProvider);
        // final notifier = ref.read(postPageProvider.notifier);

        return Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // フィルターヘッダー
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'フィルター',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  TextButton(
                    onPressed:
                        ref.read(postPageProvider.notifier).clearAllFilters,
                    child: const Text('クリア'),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // フィルター項目
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // ユーザーフィルター
                  _buildUserFilter(state, ref.read(postPageProvider.notifier)),

                  // カテゴリフィルター
                  _buildCategoryFilter(
                      state, ref.read(postPageProvider.notifier)),

                  // ソート
                  _buildSortFilter(state, ref.read(postPageProvider.notifier)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ユーザーフィルター
  Widget _buildUserFilter(PostPageState state, PostPageNotifier notifier) {
    return DropdownButton<int?>(
      value: state.selectedUserId,
      hint: const Text('ユーザー'),
      onChanged: notifier.updateUserFilter,
      items: [
        const DropdownMenuItem<int?>(
          value: null,
          child: Text('すべてのユーザー'),
        ),
        ...List.generate(10, (index) {
          final userId = index + 1;
          return DropdownMenuItem<int?>(
            value: userId,
            child: Text('ユーザー $userId'),
          );
        }),
      ],
    );
  }

  /// カテゴリフィルター
  Widget _buildCategoryFilter(PostPageState state, PostPageNotifier notifier) {
    return DropdownButton<PostLengthCategory?>(
      value: state.selectedCategory,
      hint: const Text('カテゴリ'),
      onChanged: notifier.updateCategoryFilter,
      items: [
        const DropdownMenuItem<PostLengthCategory?>(
          value: null,
          child: Text('すべてのカテゴリ'),
        ),
        ...PostLengthCategory.values.map((category) {
          return DropdownMenuItem<PostLengthCategory?>(
            value: category,
            child: Text(_getCategoryLabel(category)),
          );
        }),
      ],
    );
  }

  /// ソートフィルター
  Widget _buildSortFilter(PostPageState state, PostPageNotifier notifier) {
    return DropdownButton<SortType>(
      value: state.sortType,
      onChanged: (sortType) {
        if (sortType != null) {
          notifier.updateSortType(sortType);
        }
      },
      items: SortType.values.map((sortType) {
        return DropdownMenuItem<SortType>(
          value: sortType,
          child: Text(_getSortLabel(sortType)),
        );
      }).toList(),
    );
  }

  /// 統計カード
  Widget _buildAnalyticsCard(PostsAnalytics analytics) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '投稿統計',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('総投稿数', '${analytics.totalPosts}'),
                _buildStatItem('総ユーザー数', '${analytics.totalUsers}'),
                _buildStatItem('平均文字数', '${analytics.averageLength.toInt()}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 統計項目
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  /// 選択モードバー
  Widget _buildSelectionModeBar() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(postPageProvider);
        final notifier = ref.read(postPageProvider.notifier);

        return Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              Text(
                '${state.selectedPostIds.length}件選択中',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),

              // 全選択・全解除
              TextButton(
                onPressed: notifier.toggleSelectAll,
                child: Text(
                  state.selectedPostIds.length == notifier.currentPosts.length
                      ? '全解除'
                      : '全選択',
                ),
              ),

              // 削除
              if (state.selectedPostIds.isNotEmpty)
                ElevatedButton.icon(
                  onPressed: () => _confirmDeleteSelected(ref),
                  icon: const Icon(Icons.delete),
                  label: const Text('削除'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// メインコンテンツ
  Widget _buildMainContent() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(postPageProvider);
        final posts = ref.watch(currentPostsProvider);

        // エラー状態
        if (state.error != null && !state.isLoading) {
          // return _buildErrorState(state.error!);
        }

        // 初回読み込み中
        if (state.isLoading && posts.isEmpty) {
          return _buildLoadingState();
        }

        // 空状態
        if (!state.isLoading && posts.isEmpty) {
          return _buildEmptyState();
        }

        // 投稿リスト表示
        return _buildPostsList(posts, state);
      },
    );
  }

  /// エラー状態表示
  Widget _buildErrorState(AppException error) {
    return Center(
      child: ErrorDisplayWidget(
        error: error,
        onRetry: () => ref.read(postPageProvider.notifier).retryLastOperation(),
      ),
    );
  }

  /// ローディング状態表示
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('投稿を読み込み中...'),
        ],
      ),
    );
  }

  /// 空状態表示
  Widget _buildEmptyState() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(postPageProvider);

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                state.showSearchResults
                    ? Icons.search_off
                    : Icons.article_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                state.showSearchResults
                    ? '「${state.searchKeyword}」に一致する投稿が見つかりませんでした'
                    : '投稿がありません',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                state.showSearchResults
                    ? '別のキーワードで検索してみてください'
                    : '新しい投稿を作成してみましょう',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade500,
                    ),
              ),
              if (!state.showSearchResults) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _navigateToCreatePost,
                  icon: const Icon(Icons.add),
                  label: const Text('投稿作成'),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// 投稿リスト表示
  Widget _buildPostsList(List<Post> posts, PostPageState state) {
    return switch (state.viewMode) {
      PostsViewMode.list => _buildListView(posts, state),
      PostsViewMode.grid => _buildGridView(posts, state),
      PostsViewMode.compact => _buildCompactView(posts, state),
    };
  }

  /// リスト表示
  Widget _buildListView(List<Post> posts, PostPageState state) {
    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: posts.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        // ローディングインジケーター
        if (index >= posts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final post = posts[index];
        return _buildPostCard(post, state);
      },
    );
  }

  /// グリッド表示
  Widget _buildGridView(List<Post> posts, PostPageState state) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: posts.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= posts.length) {
          return const Center(child: CircularProgressIndicator());
        }

        final post = posts[index];
        return _buildPostCard(post, state, isCompact: true);
      },
    );
  }

  /// コンパクト表示
  Widget _buildCompactView(List<Post> posts, PostPageState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      itemCount: posts.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= posts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final post = posts[index];
        return _buildCompactPostCard(post, state);
      },
    );
  }

  /// 投稿カード（標準・グリッド）
  Widget _buildPostCard(Post post, PostPageState state,
      {bool isCompact = false}) {
    final isSelected = state.selectedPostIds.contains(post.id);
    final isDeleting = state.deletingPosts[post.id] ?? false;

    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: Stack(
        children: [
          // メインコンテンツ
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handlePostTap(post, state),
            onLongPress: state.isSelectionMode
                ? null
                : () => _startSelectionMode(post.id),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ヘッダー
                  Row(
                    children: [
                      CircleAvatar(
                        radius: isCompact ? 12 : 16,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: Text(
                          'U${post.userId}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isCompact ? 10 : 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ユーザー ${post.userId}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Text(
                              '投稿 #${post.id}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: isCompact ? 10 : null,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (!state.isSelectionMode) _buildPostActions(post),
                    ],
                  ),

                  SizedBox(height: isCompact ? 8 : 16),

                  // タイトル
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isCompact ? 14 : null,
                        ),
                    maxLines: isCompact ? 2 : (post.isLongTitle ? 2 : 1),
                    overflow: TextOverflow.ellipsis,
                  ),

                  if (!isCompact) ...[
                    const SizedBox(height: 8),

                    // 本文プレビュー
                    Text(
                      post.summary,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade700,
                          ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  SizedBox(height: isCompact ? 8 : 12),

                  // フッター
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: isCompact ? 12 : 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '約${post.estimatedReadingTime}分',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                              fontSize: isCompact ? 10 : null,
                            ),
                      ),
                      const Spacer(),
                      _buildLengthChip(post.lengthCategory,
                          isCompact: isCompact),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 選択チェックボックス
          if (state.isSelectionMode)
            Positioned(
              top: 8,
              right: 8,
              child: Checkbox(
                value: isSelected,
                onChanged: (_) => ref
                    .read(postPageProvider.notifier)
                    .togglePostSelection(post.id),
              ),
            ),

          // 削除中オーバーレイ
          if (isDeleting)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 8),
                      Text(
                        '削除中...',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// コンパクト投稿カード
  Widget _buildCompactPostCard(Post post, PostPageState state) {
    final isSelected = state.selectedPostIds.contains(post.id);
    final isDeleting = state.deletingPosts[post.id] ?? false;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary)
            : BorderSide.none,
      ),
      child: Stack(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                'U${post.userId}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: Text(
              post.summary,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            trailing: state.isSelectionMode
                ? Checkbox(
                    value: isSelected,
                    onChanged: (_) => ref
                        .read(postPageProvider.notifier)
                        .togglePostSelection(post.id),
                  )
                : _buildLengthChip(post.lengthCategory, isCompact: true),
            onTap: () => _handlePostTap(post, state),
            onLongPress: state.isSelectionMode
                ? null
                : () => _startSelectionMode(post.id),
          ),

          // 削除中オーバーレイ
          if (isDeleting)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// 投稿アクションメニュー
  Widget _buildPostActions(Post post) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
      onSelected: (action) => _handlePostAction(action, post),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility),
              SizedBox(width: 8),
              Text('詳細表示'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit),
              SizedBox(width: 8),
              Text('編集'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('削除', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
    );
  }

  /// 文字数カテゴリチップ
  Widget _buildLengthChip(PostLengthCategory category,
      {bool isCompact = false}) {
    final (label, color) = switch (category) {
      PostLengthCategory.short => ('短文', Colors.green),
      PostLengthCategory.medium => ('中文', Colors.orange),
      PostLengthCategory.long => ('長文', Colors.red),
    };

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 4 : 8,
        vertical: isCompact ? 1 : 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.shade700,
          fontSize: isCompact ? 10 : 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// フローティングアクションボタン
  Widget _buildFloatingActionButton() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(postPageProvider);

        // 選択モード中は表示しない
        if (state.isSelectionMode) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: _navigateToCreatePost,
          tooltip: '新規投稿',
          child: const Icon(Icons.add),
        );
      },
    );
  }

  /// ボトムバー
  Widget? _buildBottomBar() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(postPageProvider);

        if (!state.showSearchResults || state.searchKeyword.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '「${state.searchKeyword}」の検索結果: ${state.searchResults.length}件',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              TextButton(
                onPressed: () {
                  _searchController.clear();
                  // ref.read(postPageProvider.notifier).updateSearchKeyword('');
                },
                child: const Text('クリア'),
              ),
            ],
          ),
        );
      },
    );
  }

  // ===============================
  // 🎯 イベントハンドラー
  // ===============================

  /// 投稿タップ処理
  void _handlePostTap(Post post, PostPageState state) {
    if (state.isSelectionMode) {
      ref.read(postPageProvider.notifier).togglePostSelection(post.id);
    } else {
      _navigateToPostDetail(post);
    }
  }

  /// 選択モード開始
  void _startSelectionMode(int postId) {
    final notifier = ref.read(postPageProvider.notifier);
    notifier.toggleSelectionMode();
    notifier.togglePostSelection(postId);
  }

  /// 投稿アクション処理
  void _handlePostAction(String action, Post post) {
    switch (action) {
      case 'view':
        _navigateToPostDetail(post);
        break;
      case 'edit':
        _navigateToEditPost(post);
        break;
      case 'delete':
        _confirmDeletePost(post);
        break;
    }
  }

  /// 投稿削除確認
  void _confirmDeletePost(Post post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('投稿を削除'),
        content: Text('「${post.title}」を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // ref.read(postPageProvider.notifier).deletePost(post.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  /// 選択済み投稿削除確認
  void _confirmDeleteSelected(WidgetRef ref) {
    final selectedCount = ref.read(postPageProvider).selectedPostIds.length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('選択した投稿を削除'),
        content: Text('選択した$selectedCount件の投稿を削除しますか？\nこの操作は取り消せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // ref.read(postPageProvider.notifier).deleteSelectedPosts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('削除'),
          ),
        ],
      ),
    );
  }

  // ===============================
  // 🧭 ナビゲーション
  // ===============================

  /// 投稿詳細画面へ遷移
  void _navigateToPostDetail(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: post),
      ),
    );
  }

  /// 投稿作成画面へ遷移
  void _navigateToCreatePost() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      ),
    );
  }

  /// 投稿編集画面へ遷移
  void _navigateToEditPost(Post post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPostScreen(post: post),
      ),
    );
  }

  // ===============================
  // 🎨 ヘルパーメソッド
  // ===============================

  /// 表示モードアイコン取得
  // Icon _getViewModeIcon(PostsViewMode mode) {
  //   return switch (mode) {
  //     PostsViewMode.list => const Icon(Icons.view_list),
  //     PostsViewMode.grid => const Icon(Icons.grid_view),
  //     PostsViewMode.compact => const Icon(Icons.view_headline),
  //   };
  // }

  /// 表示モードラベル取得
  // String _getViewModeLabel(PostsViewMode mode) {
  //   return switch (mode) {
  //     PostsViewMode.list => 'リスト表示',
  //     PostsViewMode.grid => 'グリッド表示',
  //     PostsViewMode.compact => 'コンパクト表示',
  //   };
  // }

  /// カテゴリラベル取得
  String _getCategoryLabel(PostLengthCategory category) {
    return switch (category) {
      PostLengthCategory.short => '短文',
      PostLengthCategory.medium => '中文',
      PostLengthCategory.long => '長文',
    };
  }

  /// ソートラベル取得
  String _getSortLabel(SortType sortType) {
    return switch (sortType) {
      SortType.newest => '新しい順',
      SortType.oldest => '古い順',
      SortType.titleAsc => 'タイトル昇順',
      SortType.titleDesc => 'タイトル降順',
      SortType.longest => '長い順',
      SortType.shortest => '短い順',
    };
  }
}

// ===============================
// 📄 プレースホルダー画面
// ===============================

/// 投稿詳細画面（プレースホルダー）
class PostDetailScreen extends StatelessWidget {
  final Post post;

  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('投稿詳細')),
      body: Center(
        child: Text('投稿詳細画面（未実装）\n投稿: ${post.title}'),
      ),
    );
  }
}

/// 投稿作成画面（プレースホルダー）
class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新規投稿')),
      body: const Center(
        child: Text('投稿作成画面（未実装）'),
      ),
    );
  }
}

/// 投稿編集画面（プレースホルダー）
class EditPostScreen extends StatelessWidget {
  final Post post;

  const EditPostScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('投稿編集')),
      body: Center(
        child: Text('投稿編集画面（未実装）\n編集対象: ${post.title}'),
      ),
    );
  }
}

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {required TextEditingController searchController, super.key})
      : _searchController = searchController;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postPageProvider);

    // AppBar構築ロジック
    return AppBar(
      title: state.showSearchResults ? _buildSearchField() : const Text('投稿一覧'),
      elevation: 0,
      actions: [
        // 検索ボタン
        if (!state.showSearchResults)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                ref.read(postPageProvider.notifier).toggleSearchResults(),
          ),

        // 表示モード切り替え
        PopupMenuButton<PostsViewMode>(
          icon: _getViewModeIcon(state.viewMode),
          onSelected: ref.read(postPageProvider.notifier).changeViewMode,
          itemBuilder: (context) => PostsViewMode.values.map((mode) {
            return PopupMenuItem(
              value: mode,
              child: Row(
                children: [
                  _getViewModeIcon(mode),
                  const SizedBox(width: 8),
                  Text(_getViewModeLabel(mode)),
                ],
              ),
            );
          }).toList(),
        ),

        // メニュー
        _buildMenuButton(),
      ],
    );
  }

  /// 検索フィールド
  Widget _buildSearchField() {
    return Consumer(
      builder: (context, ref, child) {
        final notifier = ref.read(postPageProvider.notifier);

        return TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: '投稿を検索...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: notifier.updateSearchKeyword,
          onSubmitted: (_) => FocusScope.of(context).unfocus(),
        );
      },
    );
  }

  /// メニューボタン
  Widget _buildMenuButton() {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(postPageProvider);

        return PopupMenuButton<String>(
          onSelected: (action) => _handleMenuAction(action, ref),
          itemBuilder: (context) => [
            // 選択モード
            PopupMenuItem(
              value: 'selection_mode',
              child: Row(
                children: [
                  Icon(state.isSelectionMode ? Icons.clear : Icons.checklist),
                  const SizedBox(width: 8),
                  Text(state.isSelectionMode ? '選択解除' : '選択モード'),
                ],
              ),
            ),

            // フィルター
            PopupMenuItem(
              value: 'filters',
              child: Row(
                children: [
                  Icon(state.showFilters
                      ? Icons.filter_list_off
                      : Icons.filter_list),
                  const SizedBox(width: 8),
                  Text(state.showFilters ? 'フィルター非表示' : 'フィルター表示'),
                ],
              ),
            ),

            // 統計
            PopupMenuItem(
              value: 'analytics',
              child: Row(
                children: [
                  const Icon(Icons.analytics),
                  const SizedBox(width: 8),
                  Text(state.showAnalytics ? '統計非表示' : '統計表示'),
                ],
              ),
            ),

            const PopupMenuDivider(),

            // リフレッシュ
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh),
                  SizedBox(width: 8),
                  Text('再読み込み'),
                ],
              ),
            ),

            // エラー詳細
            if (state.error != null)
              const PopupMenuItem(
                value: 'error_details',
                child: Row(
                  children: [
                    Icon(Icons.bug_report),
                    SizedBox(width: 8),
                    Text('エラー詳細'),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Icon _getViewModeIcon(PostsViewMode mode) {
    return switch (mode) {
      PostsViewMode.list => const Icon(Icons.view_list),
      PostsViewMode.grid => const Icon(Icons.grid_view),
      PostsViewMode.compact => const Icon(Icons.view_headline),
    };
  }

  String _getViewModeLabel(PostsViewMode mode) {
    return switch (mode) {
      PostsViewMode.list => 'リスト表示',
      PostsViewMode.grid => 'グリッド表示',
      PostsViewMode.compact => 'コンパクト表示',
    };
  }

  /// メニューアクション処理
  void _handleMenuAction(String action, WidgetRef ref) {
    final notifier = ref.read(postPageProvider.notifier);

    switch (action) {
      case 'selection_mode':
        notifier.toggleSelectionMode();
        break;
      case 'filters':
        notifier.toggleFilters();
        break;
      case 'analytics':
        notifier.toggleAnalytics();
        break;
      case 'refresh':
        notifier.refreshPosts();
        break;
      case 'error_details':
        notifier.toggleErrorDetails();
        break;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
