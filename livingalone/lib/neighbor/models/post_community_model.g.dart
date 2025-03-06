// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_community_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostCommunityModel _$PostCommunityModelFromJson(Map<String, dynamic> json) =>
    PostCommunityModel(
      topic: json['topic'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PostCommunityModelToJson(PostCommunityModel instance) =>
    <String, dynamic>{
      'topic': instance.topic,
      'title': instance.title,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
    };
