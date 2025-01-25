// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      roomId: json['roomId'] as String,
      opponentName: json['opponentName'] as String,
      opponentProfileUrl: json['opponentProfileUrl'] as String,
      title: json['title'] as String,
      lastMessage: json['lastMessage'] as String,
      type: json['chatType'] as String,
      updatedAt: DateTime.parse(json['lastMessageTime'] as String),
      hasUnreadMessages: json['hasUnreadMessages'] as bool? ?? false,
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'roomId': instance.roomId,
      'opponentName': instance.opponentName,
      'opponentProfileUrl': instance.opponentProfileUrl,
      'title': instance.title,
      'lastMessage': instance.lastMessage,
      'chatType': instance.type,
      'lastMessageTime': instance.updatedAt.toIso8601String(),
      'hasUnreadMessages': instance.hasUnreadMessages,
    };
