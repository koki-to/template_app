import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:template_app/features/function/data/models/post_model.dart';

// 🔧 コード生成用ファイル指定
part 'post_client.g.dart';

// ===============================
// 🌐 PostClient：投稿関連API クライアント
// ===============================

/// JSONPlaceholder API の投稿関連エンドポイントを定義
///
/// 【現場でのRetrofit使用理由】
/// 1. 型安全性：コンパイル時にAPI仕様とコードの整合性をチェック
/// 2. 自動化：リクエスト・レスポンスの変換を自動生成
/// 3. 保守性：API仕様変更時の影響範囲を最小化
/// 4. テスト性：モック作成が容易
///
/// 【APIドキュメント】
/// https://jsonplaceholder.typicode.com/
@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class PostClient {
  /// ファクトリーコンストラクタ
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final dio = DioClient.instance.dio;
  /// final postClient = PostClient(dio);
  /// ```
  factory PostClient(Dio dio, {String? baseUrl}) = _PostClient;

  // ===============================
  // 📖 READ 操作（取得系API）
  // ===============================

  /// すべての投稿を取得
  ///
  /// 【エンドポイント】
  /// GET /posts
  ///
  /// 【現場での使用例】
  /// ```dart
  /// try {
  ///   final posts = await postClient.getAllPosts();
  ///   print('取得した投稿数: ${posts.length}');
  /// } catch (e) {
  ///   // エラーハンドリング
  /// }
  /// ```
  ///
  /// 【レスポンス例】
  /// 100件の投稿データのリスト
  @GET('/posts')
  Future<List<Post>> getAllPosts();

  /// 特定の投稿を取得
  ///
  /// 【エンドポイント】
  /// GET /posts/{id}
  ///
  /// 【パラメータ】
  /// - [id]: 投稿ID（1-100）
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final post = await postClient.getPost(1);
  /// print('タイトル: ${post.title}');
  /// ```
  @GET('/posts/{id}')
  Future<Post> getPost(@Path('id') int id);

  /// 特定ユーザーの投稿を取得
  ///
  /// 【エンドポイント】
  /// GET /posts?userId={userId}
  ///
  /// 【パラメータ】
  /// - [userId]: ユーザーID（1-10）
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final userPosts = await postClient.getPostsByUser(1);
  /// print('ユーザー1の投稿数: ${userPosts.length}');
  /// ```
  @GET('/posts')
  Future<List<Post>> getPostsByUser(@Query('userId') int userId);

  /// ページング付き投稿取得
  ///
  /// 【エンドポイント】
  /// GET /posts?_start={start}&_limit={limit}
  ///
  /// 【パラメータ】
  /// - [start]: 開始位置（0-based）
  /// - [limit]: 取得件数
  ///
  /// 【現場での使用例】
  /// ```dart
  /// // 最初の10件を取得
  /// final firstPage = await postClient.getPostsPaginated(0, 10);
  /// // 次の10件を取得
  /// final secondPage = await postClient.getPostsPaginated(10, 10);
  /// ```
  @GET('/posts')
  Future<List<Post>> getPostsPaginated(
    @Query('_start') int start,
    @Query('_limit') int limit,
  );

  // ===============================
  // ✏️ CREATE・UPDATE・DELETE 操作
  // ===============================

  /// 新規投稿作成
  ///
  /// 【エンドポイント】
  /// POST /posts
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final newPost = CreatePostRequest(
  ///   userId: 1,
  ///   title: '新しい投稿',
  ///   body: '投稿内容...',
  /// );
  /// final createdPost = await postClient.createPost(newPost);
  /// print('作成された投稿ID: ${createdPost.id}');
  /// ```
  ///
  /// 【注意】
  /// JSONPlaceholderは実際にはデータを保存しないため、
  /// 実際のIDは101が返される（モックレスポンス）
  @POST('/posts')
  Future<Post> createPost(@Body() CreatePostRequest request);

  /// 投稿の完全更新
  ///
  /// 【エンドポイント】
  /// PUT /posts/{id}
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final updateRequest = CreatePostRequest(
  ///   userId: 1,
  ///   title: '更新されたタイトル',
  ///   body: '更新された内容',
  /// );
  /// final updatedPost = await postClient.updatePost(1, updateRequest);
  /// ```
  @PUT('/posts/{id}')
  Future<Post> updatePost(
    @Path('id') int id,
    @Body() CreatePostRequest request,
  );

  /// 投稿の部分更新
  ///
  /// 【エンドポイント】
  /// PATCH /posts/{id}
  ///
  /// 【現場での使用例】
  /// ```dart
  /// // タイトルのみ更新
  /// final patchRequest = UpdatePostRequest(title: '新しいタイトル');
  /// final updatedPost = await postClient.patchPost(1, patchRequest);
  /// ```
  @PATCH('/posts/{id}')
  Future<Post> patchPost(
    @Path('id') int id,
    @Body() UpdatePostRequest request,
  );

  /// 投稿削除
  ///
  /// 【エンドポイント】
  /// DELETE /posts/{id}
  ///
  /// 【現場での使用例】
  /// ```dart
  /// await postClient.deletePost(1);
  /// print('投稿が削除されました');
  /// ```
  ///
  /// 【戻り値】
  /// 空のオブジェクト（{}）が返される
  @DELETE('/posts/{id}')
  Future<void> deletePost(@Path('id') int id);

  // ===============================
  // 🔍 検索・フィルタリング系API
  // ===============================

  /// タイトルで投稿を検索
  ///
  /// 【エンドポイント】
  /// GET /posts?title_like={keyword}
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final searchResults = await postClient.searchPostsByTitle('sunt');
  /// print('検索結果: ${searchResults.length}件');
  /// ```
  ///
  /// 【注意】
  /// JSONPlaceholderでは title_like パラメータは正式サポートされていないため、
  /// 実際にはすべての投稿が返される場合があります
  @GET('/posts')
  Future<List<Post>> searchPostsByTitle(@Query('title_like') String keyword);

  /// 複数の投稿IDで一括取得
  ///
  /// 【エンドポイント】
  /// GET /posts?id={id1}&id={id2}&...
  ///
  /// 【現場での使用例】
  /// ```dart
  /// final selectedPosts = await postClient.getMultiplePosts([1, 5, 10]);
  /// ```
  @GET('/posts')
  Future<List<Post>> getMultiplePosts(@Query('id') List<int> ids);

  // // ===============================
  // // 📊 統計・メタデータ系API
  // // ===============================

  // /// 投稿の総数を取得（ヘッダー情報から）
  // ///
  // /// 【現場での使用例】
  // /// ```dart
  // /// final response = await postClient.getPostsWithHeaders();
  // /// final totalCount = response.headers.value('x-total-count');
  // /// print('総投稿数: $totalCount');
  // /// ```
  @GET('/posts')
  Future<HttpResponse<List<Post>>> getPostsWithHeaders();

  // // ===============================
  // // 🧪 開発・テスト用メソッド
  // // ===============================

  // /// ヘルスチェック用エンドポイント
  // ///
  // /// 【現場での使用例】
  // /// ```dart
  // /// try {
  // ///   await postClient.healthCheck();
  // ///   print('API サーバーは正常です');
  // /// } catch (e) {
  // ///   print('API サーバーに問題があります: $e');
  // /// }
  // /// ```
  @GET('/posts/1')
  Future<Post> healthCheck();

  // /// 意図的にエラーを発生させる（テスト用）
  // ///
  // /// 【現場での使用例】
  // /// エラーハンドリングのテスト時に使用
  // /// ```dart
  // /// try {
  // ///   await postClient.triggerError();
  // /// } catch (e) {
  // ///   print('期待通りエラーが発生: $e');
  // /// }
  // /// ```
  @GET('/posts/999999') // 存在しないIDで404エラーを発生
  Future<Post> triggerError();
}
