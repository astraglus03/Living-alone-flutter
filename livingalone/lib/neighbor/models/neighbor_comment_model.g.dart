// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'neighbor_comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NeighborCommentModel _$NeighborCommentModelFromJson(
        Map<String, dynamic> json) =>
    NeighborCommentModel(
      id: json['id'] as String,
      username: json['username'] as String,
      content: json['content'] as String,
      time: json['time'] as String,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => NeighborCommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isAuthor: json['isAuthor'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      userProfileUrl: json['userProfileUrl'] as String?,
    );

Map<String, dynamic> _$NeighborCommentModelToJson(
        NeighborCommentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'content': instance.content,
      'time': instance.time,
      'replies': instance.replies,
      'isAuthor': instance.isAuthor,
      'isDeleted': instance.isDeleted,
      'userProfileUrl': instance.userProfileUrl,
    };
