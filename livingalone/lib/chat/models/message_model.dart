import 'package:json_annotation/json_annotation.dart';

part 'message_model.g.dart';

@JsonSerializable()
class ChatMessage {
  final String messageId;
  final String senderId;
  final String content;
  @JsonKey(name: 'createdAt')
  final DateTime timestamp;
  final String? imageUrl;
  @JsonKey(defaultValue: false)
  final bool isMe;
  @JsonKey(defaultValue: false)
  final bool isRead;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.imageUrl,
    required this.isMe,
    required this.isRead,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json)
    => _$ChatMessageFromJson(json);
  
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}
