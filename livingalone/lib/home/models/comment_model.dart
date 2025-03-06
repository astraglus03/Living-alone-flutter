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

  Map<String, dynamic> toJson() => _$CommentModelToJson(this);

  CommentModel copyWith({
    String? username,
    String? content,
    String? time,
    bool? isAuthor,
    bool? isDeleted,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      username: username ?? this.username,
      content: content ?? this.content,
      time: time ?? this.time,
      isAuthor: isAuthor ?? this.isAuthor,
      isDeleted: isDeleted ?? this.isDeleted,
      replies: replies ?? this.replies,
    );
  }

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

  // 더미 데이터 생성
  static List<CommentModel> getDummyComments() {
    return [
      CommentModel(
        username: "김철수",
        content: "저도 필요했었는데 감사합니다!",
        time: "2024.01.15 14:30",
        isAuthor: false,
        replies: [
          CommentModel(
            username: "네이름은 코난",
            content: "네 필요하시다면 연락주세요~",
            time: "2024.01.15 14:35",
            isAuthor: true,
          ),
        ],
      ),
      CommentModel(
        username: "이영희",
        content: "혹시 아직 빌려주실 수 있나요?",
        time: "2024.01.15 15:00",
        isAuthor: false,
      ),
    ];
  }
}