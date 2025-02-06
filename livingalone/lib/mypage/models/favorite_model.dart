import 'package:json_annotation/json_annotation.dart';
import 'package:livingalone/common/enum/post_type.dart';
import 'package:livingalone/common/enum/room_enums.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  final String id;
  final String itemId;
  final PostType type;
  final String title;
  final String? thumbnailUrl;
  final bool isTransferred;
  final String location;
  
  // 자취방 관련 필드
  final String? buildingType;    // 아파트, 빌라, 주택, 오피스텔
  final String? propertyType;    // 원룸(오픈형), 원룸(분리형), 투룸, 쓰리룸
  final String? rentType;        // 월세, 전세, 단기양도
  final int? deposit;
  final int? monthlyRent;
  final int? maintenance;
  
  // 이용권 관련 필드
  final String? ticketType;      // 헬스장, PT, 필라테스 등
  final int? remainingDays;
  final int? price;
  
  // 공통 필드
  final int viewCount;
  final int commentCount;
  final int chatCount;
  final DateTime createdAt;
  bool isFavorite;

  FavoriteModel({
    required this.id,
    required this.itemId,
    required this.type,
    required this.title,
    this.thumbnailUrl,
    required this.isTransferred,
    required this.location,
    this.buildingType,
    this.propertyType,
    this.rentType,
    this.deposit,
    this.monthlyRent,
    this.maintenance,
    this.ticketType,
    this.remainingDays,
    this.price,
    required this.viewCount,
    required this.commentCount,
    required this.chatCount,
    required this.createdAt,
    required this.isFavorite,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);

  // Room 모델에서 변환
  factory FavoriteModel.fromRoom(dynamic room, {required bool isFavorite}) {
    return FavoriteModel(
      id: room.id,
      itemId: room.id,
      type: PostType.room,
      title: room.title,
      thumbnailUrl: room.thumbnailUrl,
      isTransferred: room.isTransferred,
      location: room.location,
      buildingType: room.buildingType,
      propertyType: room.propertyType,
      rentType: room.rentType,
      deposit: room.deposit,
      monthlyRent: room.monthlyRent,
      maintenance: room.maintenance,
      viewCount: room.views ?? 0,
      commentCount: room.comments,
      chatCount: room.chatRooms,
      createdAt: room.createdAt,
      isFavorite: isFavorite,
    );
  }

  // Ticket 모델에서 변환
  factory FavoriteModel.fromTicket(dynamic ticket, {required bool isFavorite}) {
    return FavoriteModel(
      id: ticket.id,
      itemId: ticket.id,
      type: PostType.ticket,
      title: ticket.title,
      thumbnailUrl: ticket.thumbnailUrl,
      isTransferred: ticket.isTransferred,
      location: ticket.location,
      ticketType: ticket.ticketType,
      viewCount: ticket.views ?? 0,
      commentCount: ticket.comments,
      chatCount: ticket.chatRooms,
      createdAt: ticket.createdAt,
      isFavorite: isFavorite,
    );
  }

  FavoriteModel copyWith({
    String? id,
    String? itemId,
    PostType? type,
    String? title,
    String? thumbnailUrl,
    bool? isTransferred,
    String? location,
    String? buildingType,
    String? propertyType,
    String? rentType,
    int? deposit,
    int? monthlyRent,
    int? maintenance,
    String? ticketType,
    int? viewCount,
    int? commentCount,
    int? chatCount,
    DateTime? createdAt,
    bool? isFavorite,
  }) {
    return FavoriteModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      type: type ?? this.type,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isTransferred: isTransferred ?? this.isTransferred,
      location: location ?? this.location,
      buildingType: buildingType ?? this.buildingType,
      propertyType: propertyType ?? this.propertyType,
      rentType: rentType ?? this.rentType,
      deposit: deposit ?? this.deposit,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      maintenance: maintenance ?? this.maintenance,
      ticketType: ticketType ?? this.ticketType,
      viewCount: viewCount ?? this.viewCount,
      commentCount: commentCount ?? this.commentCount,
      chatCount: chatCount ?? this.chatCount,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
} 