// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      messageId: json['messageId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['createdAt'] as String),
      imageUrl: json['imageUrl'] as String?,
      isMe: json['isMe'] as bool? ?? false,
      isRead: json['isRead'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'senderId': instance.senderId,
      'content': instance.content,
      'createdAt': instance.timestamp.toIso8601String(),
      'imageUrl': instance.imageUrl,
      'isMe': instance.isMe,
      'isRead': instance.isRead,
    };
