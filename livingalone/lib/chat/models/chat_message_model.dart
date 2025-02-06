import 'package:json_annotation/json_annotation.dart';

part 'chat_message_model.g.dart';

@JsonSerializable()
class ChatMessage {
  @JsonKey(name: 'id')
  final String messageId;
  
  @JsonKey(name: 'roomId')
  final String roomId;
  
  @JsonKey(name: 'senderId')
  final String senderId;
  
  final String content;
  
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  
  @JsonKey(name: 'isRead')
  final bool isRead;
  
  @JsonKey(name: 'type')
  final String messageType; // TEXT, IMAGE, SYSTEM

  const ChatMessage({
    required this.messageId,
    required this.roomId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isRead,
    required this.messageType,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) 
    => _$ChatMessageFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  ChatMessage copyWith({
    String? messageId,
    String? roomId,
    String? senderId,
    String? content,
    DateTime? createdAt,
    bool? isRead,
    String? messageType,
  }) {
    return ChatMessage(
      messageId: messageId ?? this.messageId,
      roomId: roomId ?? this.roomId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      messageType: messageType ?? this.messageType,
    );
  }
} 