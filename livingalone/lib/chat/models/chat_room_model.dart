import 'package:json_annotation/json_annotation.dart';

part 'chat_room_model.g.dart';

@JsonSerializable()
class ChatRoom {
  final String roomId;
  final String opponentName;
  final String opponentProfileUrl;
  final String title;       // 이용권 또는 자취방 제목
  final String lastMessage;
  @JsonKey(name: 'chatType')
  final String type;        // 'TICKET' or 'ROOM'
  @JsonKey(name: 'lastMessageTime')
  final DateTime updatedAt;
  final bool hasUnreadMessages;

  ChatRoom({
    required this.roomId,
    required this.opponentName,
    required this.opponentProfileUrl,
    required this.title,
    required this.lastMessage,
    required this.type,
    required this.updatedAt,
    this.hasUnreadMessages = false,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) 
    => _$ChatRoomFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}
