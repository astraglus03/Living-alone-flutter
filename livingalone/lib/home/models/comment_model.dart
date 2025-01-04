import 'package:json_annotation/json_annotation.dart';
import 'package:livingalone/common/utils/data_utils.dart';
import 'package:intl/intl.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class CommentModel {
  final String username;
  final String content;
  // @JsonKey(
  //   toJson: DataUtils.stringtoDateTime,
  // )
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
    final formatDate = DateFormat('yy/mm/dd - HH:MM:ss').format(DateTime.now());
    return CommentModel(
      username: '',
      content: '삭제된 메시지입니다.',
      time: formatDate,
      replies: replies,
      isAuthor: isAuthor,
      isDeleted: true,
    );
  }
}