import 'package:json_annotation/json_annotation.dart';

part 'post_detail_model.g.dart';

@JsonSerializable()
class PostDetailModel {
  final String id;
  final String topic;
  final String title;
  final String content;
  final List<String> imageUrls;
  final String authorId;
  final String authorName;
  final String authorProfileUrl;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  final int likeCount;
  final int commentCount;
  final bool isLiked;

  PostDetailModel({
    required this.id,
    required this.topic,
    required this.title,
    required this.content,
    required this.imageUrls,
    required this.authorId,
    required this.authorName,
    required this.authorProfileUrl,
    required this.createdAt,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
  });

  factory PostDetailModel.fromJson(Map<String, dynamic> json) =>
      _$PostDetailModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$PostDetailModelToJson(this);

  // 더미 데이터 생성
  static PostDetailModel getDummy() {
    return PostDetailModel(
      id: '1',
      topic: '도움요청',
      title: '전동 드라이버 빌려주실 분',
      content: '빌려주시면 사례 해드릴게요!!',
      imageUrls: [
        // 'https://picsum.photos/200/300',
        // 'https://picsum.photos/200/301',
      ],
      authorId: 'user1',
      authorName: '네이름은 코난',
      authorProfileUrl: 'https://picsum.photos/50/50',
      createdAt: DateTime.now().subtract(Duration(hours: 2)),
      likeCount: 5,
      commentCount: 4,
      isLiked: false,
    );
  }
} 