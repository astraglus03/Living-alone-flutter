// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentModel _$CommentModelFromJson(Map<String, dynamic> json) => CommentModel(
      username: json['username'] as String,
      content: json['content'] as String,
      time: json['time'] as String,
      replies: (json['replies'] as List<dynamic>?)
          ?.map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isAuthor: json['isAuthor'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
    );

Map<String, dynamic> _$CommentModelToJson(CommentModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'content': instance.content,
      'time': instance.time,
      'replies': instance.replies,
      'isAuthor': instance.isAuthor,
      'isDeleted': instance.isDeleted,
    };
