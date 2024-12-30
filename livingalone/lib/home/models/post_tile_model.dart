import 'package:json_annotation/json_annotation.dart';
part 'post_tile_model.g.dart';

@JsonSerializable()
class Post {
  final String id;
  final String thumbnailUrl;
  final String title;
  final String subTitle1;
  final String subTitle2;
  final String subTitle3;
  final String subTitle4;
  final int likes;
  final int comments;
  final int scraps;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.thumbnailUrl,
    required this.title,
    required this.subTitle1,
    required this.subTitle2,
    required this.subTitle3,
    required this.subTitle4,
    required this.likes,
    required this.comments,
    required this.scraps,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
