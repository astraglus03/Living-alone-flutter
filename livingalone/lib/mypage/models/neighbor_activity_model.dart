import 'package:json_annotation/json_annotation.dart';

part 'neighbor_activity_model.g.dart';

@JsonSerializable()
class NeighborActivityModel {
  final String id;
  final String title;
  final String content;
  final String location;
  final DateTime createdAt;
  final int viewCount;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final String? thumbnailUrl;
  final String category; // 동네질문, 동네소식, 동네맛집, 취미생활, 일상
  final String username;
  final String? userProfileUrl;
  final bool isMyPost;
  final bool isParticipated;

  NeighborActivityModel({
    required this.id,
    required this.title,
    required this.content,
    required this.location,
    required this.createdAt,
    required this.viewCount,
    required this.commentCount,
    required this.likeCount,
    required this.isLiked,
    this.thumbnailUrl,
    required this.category,
    required this.username,
    this.userProfileUrl,
    required this.isMyPost,
    required this.isParticipated,
  });

  factory NeighborActivityModel.fromJson(Map<String, dynamic> json) =>
      _$NeighborActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$NeighborActivityModelToJson(this);
} 