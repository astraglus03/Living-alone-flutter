
import 'package:json_annotation/json_annotation.dart';
part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String username;
  final String content;
  final String time;
  final bool isAuthor;
  final List<CommentModel>? replies;

  CommentModel({
    required this.username,
    required this.content,
    required this.time,
    this.isAuthor = false,
    this.replies,
  });

  factory CommentModel.fromJson(Map<String,dynamic> json)
  => _$CommentModelFromJson(json);
}