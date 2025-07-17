// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoDto _$TodoDtoFromJson(Map<String, dynamic> json) => _TodoDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool,
      createdAt: json['createdAt'] as String,
      completedAt: json['completedAt'] as String?,
      priority: json['priority'] as String? ?? 'medium',
    );

Map<String, dynamic> _$TodoDtoToJson(_TodoDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt,
      'completedAt': instance.completedAt,
      'priority': instance.priority,
    };
