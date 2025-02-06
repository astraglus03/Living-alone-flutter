import 'package:json_annotation/json_annotation.dart';
import 'package:livingalone/common/enum/post_type.dart';

part 'chat_room_model.g.dart';

@JsonSerializable()
class ChatRoom {
  @JsonKey(name: 'id')
  final String roomId;
  
  @JsonKey(name: 'opponent')
  final String opponentName;
  
  @JsonKey(name: 'opponentProfile')
  final String opponentProfileUrl;
  
  final String title;
  final String lastMessage;
  
  @JsonKey(name: 'type')
  final String type;        // 'TICKET' or 'ROOM'
  
  @JsonKey(name: 'updatedAt')
  final DateTime lastMessageTime;
  
  @JsonKey(name: 'unread')
  final bool hasUnreadMessages;
  
  // Post related information
  final String location;
  final String? thumbnailUrl;
  final String? buildingType;
  final String? propertyType;
  final String? rentType;
  final int? deposit;
  final int? monthlyRent;
  final int? maintenance;
  
  // Ticket specific information
  final String? ticketType;
  final int? remainingDays;
  final int? price;

  const ChatRoom({
    required this.roomId,
    required this.opponentName,
    required this.opponentProfileUrl,
    required this.title,
    required this.lastMessage,
    required this.type,
    required this.lastMessageTime,
    this.hasUnreadMessages = false,
    required this.location,
    this.thumbnailUrl,
    this.buildingType,
    this.propertyType,
    this.rentType,
    this.deposit,
    this.monthlyRent,
    this.maintenance,
    this.ticketType,
    this.remainingDays,
    this.price,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) 
    => _$ChatRoomFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);

  ChatRoom copyWith({
    String? roomId,
    String? opponentName,
    String? opponentProfileUrl,
    String? title,
    String? lastMessage,
    String? type,
    DateTime? lastMessageTime,
    bool? hasUnreadMessages,
    String? location,
    String? thumbnailUrl,
    String? buildingType,
    String? propertyType,
    String? rentType,
    int? deposit,
    int? monthlyRent,
    int? maintenance,
    String? ticketType,
    int? remainingDays,
    int? price,
  }) {
    return ChatRoom(
      roomId: roomId ?? this.roomId,
      opponentName: opponentName ?? this.opponentName,
      opponentProfileUrl: opponentProfileUrl ?? this.opponentProfileUrl,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      type: type ?? this.type,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      hasUnreadMessages: hasUnreadMessages ?? this.hasUnreadMessages,
      location: location ?? this.location,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      buildingType: buildingType ?? this.buildingType,
      propertyType: propertyType ?? this.propertyType,
      rentType: rentType ?? this.rentType,
      deposit: deposit ?? this.deposit,
      monthlyRent: monthlyRent ?? this.monthlyRent,
      maintenance: maintenance ?? this.maintenance,
      ticketType: ticketType ?? this.ticketType,
      remainingDays: remainingDays ?? this.remainingDays,
      price: price ?? this.price,
    );
  }
}
