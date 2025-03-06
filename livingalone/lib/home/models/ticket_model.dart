import 'package:json_annotation/json_annotation.dart';

part 'ticket_model.g.dart';

@JsonSerializable()
class TicketModel {
  final String id;          // 고유 id
  final String postType;    // 방 or 이용권 여부
  final String title;       // 제목
  final String location;    // 지역
  final String ticketType;  // 이용권 유형
  final DateTime createdAt; // 게시물 생성 날짜
  final bool isTransferred;  // 양도 상태
  final bool isFavorite;    // 현재 사용자가 좋아요 했는지 여부
  // final String thumbnailUrl; // 썸네일
  // final int likes;           // 찜 횟수
  // final int comments;        // 전체 댓글수
  // final int chatRooms;       // 현재 참여중인 대화 개수

  TicketModel({
    required this.id,
    required this.postType,
    required this.title,
    required this.location,
    required this.ticketType,
    required this.createdAt,
    required this.isTransferred,
    this.isFavorite = false,
    // required this.thumbnailUrl,
    // required this.likes,
    // required this.comments,
    // required this.chatRooms,
  });

  factory TicketModel.fromJson(Map<String,dynamic> json)
  => _$TicketModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$TicketModelToJson(this);
  
  // 객체의 일부 필드만 업데이트하여 새 객체를 생성하는 메서드
  TicketModel copyWith({
    String? id,
    String? postType,
    String? title,
    String? location,
    String? ticketType,
    DateTime? createdAt,
    bool? isTransferred,
    bool? isFavorite,
  }) {
    return TicketModel(
      id: id ?? this.id,
      postType: postType ?? this.postType,
      title: title ?? this.title,
      location: location ?? this.location,
      ticketType: ticketType ?? this.ticketType,
      createdAt: createdAt ?? this.createdAt,
      isTransferred: isTransferred ?? this.isTransferred,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
