import 'package:json_annotation/json_annotation.dart';

part 'neighbor_comment_model.g.dart';

@JsonSerializable()
class NeighborCommentModel {
  final String id;
  final String username;
  final String content;
  final String time;
  final List<NeighborCommentModel>? replies;
  final bool isAuthor;
  final bool isDeleted;
  final String? userProfileUrl;

  NeighborCommentModel({
    required this.id,
    required this.username,
    required this.content,
    required this.time,
    this.replies,
    this.isAuthor = false,
    this.isDeleted = false,
    this.userProfileUrl,
  });

  factory NeighborCommentModel.fromJson(Map<String, dynamic> json) =>
      _$NeighborCommentModelFromJson(json);

  Map<String, dynamic> toJson() => _$NeighborCommentModelToJson(this);

  NeighborCommentModel copyWith({
    String? id,
    String? username,
    String? content,
    String? time,
    List<NeighborCommentModel>? replies,
    bool? isAuthor,
    bool? isDeleted,
    String? userProfileUrl,
  }) {
    return NeighborCommentModel(
      id: id ?? this.id,
      username: username ?? this.username,
      content: content ?? this.content,
      time: time ?? this.time,
      replies: replies ?? this.replies,
      isAuthor: isAuthor ?? this.isAuthor,
      isDeleted: isDeleted ?? this.isDeleted,
      userProfileUrl: userProfileUrl ?? this.userProfileUrl,
    );
  }

  // 더미 데이터 생성
  static List<NeighborCommentModel> getDummyComments() {
    return [
      NeighborCommentModel(
        id: '1',
        username: "김철수",
        content: "저도 필요했었는데 감사합니다!",
        time: "2024.01.15 14:30",
        userProfileUrl: "https://picsum.photos/50/50",
        isAuthor: false,
        replies: [
          NeighborCommentModel(
            id: '2',
            username: "네이름은 코난",
            content: "네 필요하시다면 연락주세요~",
            time: "2024.01.15 14:35",
            userProfileUrl: "https://picsum.photos/50/51",
            isAuthor: true,
          ),
        ],
      ),
      NeighborCommentModel(
        id: '3',
        username: "이영희",
        content: "혹시 아직 빌려주실 수 있나요?",
        time: "2024.01.15 15:00",
        userProfileUrl: "https://picsum.photos/50/52",
        isAuthor: false,
      ),
    ];
  }
} 