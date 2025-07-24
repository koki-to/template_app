import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_app/features/function/data/datasources/post_client.dart';
import 'package:template_app/features/function/data/datasources/post_client_factory.dart';
import 'package:template_app/features/function/data/repositories/post_repository_impl.dart';
import 'package:template_app/features/function/domain/repositories/post_repository.dart';

// ===============================
// 🏭 プロバイダー依存関係の定義
// ===============================

/// PostsApi のプロバイダー
///
/// 【現場での使用理由】
/// - シングルトンパターンでAPIクライアントを管理
/// - テスト時にモックで差し替え可能
/// - 依存性注入（DI）の実現
final postClientProvider = Provider<PostClient>((ref) {
  return PostClientFactory.create();
});

/// PostsRepository のプロバイダー
///
/// 【依存関係】
/// PostsRepository <- PostsApi <- DioClient
final postRepositoryProvider = Provider<PostRepository>((ref) {
  final postClient = ref.watch(postClientProvider);
  return PostRepositoryImpl(postClient);
});
