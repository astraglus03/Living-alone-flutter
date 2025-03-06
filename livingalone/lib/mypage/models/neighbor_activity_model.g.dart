// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neighbor_activity_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeighborActivityModel _$NeighborActivityModelFromJson(
        Map<String, dynamic> json) =>
    NeighborActivityModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      location: json['location'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      viewCount: (json['viewCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      likeCount: (json['likeCount'] as num).toInt(),
      isLiked: json['isLiked'] as bool,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      category: json['category'] as String,
      username: json['username'] as String,
      userProfileUrl: json['userProfileUrl'] as String?,
      isMyPost: json['isMyPost'] as bool,
      isParticipated: json['isParticipated'] as bool,
    );

Map<String, dynamic> _$NeighborActivityModelToJson(
        NeighborActivityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'location': instance.location,
      'createdAt': instance.createdAt.toIso8601String(),
      'viewCount': instance.viewCount,
      'commentCount': instance.commentCount,
      'likeCount': instance.likeCount,
      'isLiked': instance.isLiked,
      'thumbnailUrl': instance.thumbnailUrl,
      'category': instance.category,
      'username': instance.username,
      'userProfileUrl': instance.userProfileUrl,
      'isMyPost': instance.isMyPost,
      'isParticipated': instance.isParticipated,
    };
