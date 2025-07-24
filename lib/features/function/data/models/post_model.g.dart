// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
      userId: (json['userId'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
      'userId': instance.userId,
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
    };

_PostList _$PostListFromJson(Map<String, dynamic> json) => _PostList(
      posts: (json['posts'] as List<dynamic>?)
              ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      hasMore: json['hasMore'] as bool? ?? false,
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$PostListToJson(_PostList instance) => <String, dynamic>{
      'posts': instance.posts,
      'totalCount': instance.totalCount,
      'hasMore': instance.hasMore,
      'currentPage': instance.currentPage,
    };

_CreatePostRequest _$CreatePostRequestFromJson(Map<String, dynamic> json) =>
    _CreatePostRequest(
      userId: (json['userId'] as num).toInt(),
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$CreatePostRequestToJson(_CreatePostRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
    };

_UpdatePostRequest _$UpdatePostRequestFromJson(Map<String, dynamic> json) =>
    _UpdatePostRequest(
      userId: (json['userId'] as num?)?.toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
    );

Map<String, dynamic> _$UpdatePostRequestToJson(_UpdatePostRequest instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
    };
