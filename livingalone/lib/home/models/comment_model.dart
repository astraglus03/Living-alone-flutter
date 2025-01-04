import 'package:json_annotation/json_annotation.dart';
part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String username;
  final String content;
  final String time;
  final List<CommentModel>? replies;
  final bool isAuthor;
  final bool isDeleted;

  CommentModel({
    required this.username,
    required this.content,
    required this.time,
    this.replies,
    this.isAuthor = false,
    this.isDeleted = false,
  });

  factory CommentModel.fromJson(Map<String,dynamic> json)
  => _$CommentModelFromJson(json);

  CommentModel copyWithDeleted() {
    return CommentModel(
      username: '',
      content: '삭제된 메시지입니다.',
      time: '',
      replies: replies,
      isAuthor: isAuthor,
      isDeleted: true,
    );
  }
}