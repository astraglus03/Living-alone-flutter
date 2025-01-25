import 'package:json_annotation/json_annotation.dart';

part 'post_community_model.g.dart';

@JsonSerializable()
class PostCommunityModel {
  final String topic;
  final String title;
  final String content;
  final List<String> imageUrls;

  PostCommunityModel({
    required this.topic,
    required this.title,
    required this.content,
    this.imageUrls = const [],
  });

  factory PostCommunityModel.fromJson(Map<String, dynamic> json) =>
      _$PostCommunityModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostCommunityModelToJson(this);
} 