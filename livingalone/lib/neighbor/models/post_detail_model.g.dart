// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDetailModel _$PostDetailModelFromJson(Map<String, dynamic> json) =>
    PostDetailModel(
      id: json['id'] as String,
      topic: json['topic'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      authorProfileUrl: json['authorProfileUrl'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      likeCount: (json['likeCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
    );

Map<String, dynamic> _$PostDetailModelToJson(PostDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'title': instance.title,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'authorProfileUrl': instance.authorProfileUrl,
      'created_at': instance.createdAt.toIso8601String(),
      'likeCount': instance.likeCount,
      'commentCount': instance.commentCount,
      'isLiked': instance.isLiked,
    };
