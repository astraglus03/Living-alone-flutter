// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
      roomId: json['id'] as String,
      opponentName: json['opponent'] as String,
      opponentProfileUrl: json['opponentProfile'] as String,
      title: json['title'] as String,
      lastMessage: json['lastMessage'] as String,
      type: json['type'] as String,
      lastMessageTime: DateTime.parse(json['updatedAt'] as String),
      hasUnreadMessages: json['unread'] as bool? ?? false,
      location: json['location'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      buildingType: json['buildingType'] as String?,
      propertyType: json['propertyType'] as String?,
      rentType: json['rentType'] as String?,
      deposit: (json['deposit'] as num?)?.toInt(),
      monthlyRent: (json['monthlyRent'] as num?)?.toInt(),
      maintenance: (json['maintenance'] as num?)?.toInt(),
      ticketType: json['ticketType'] as String?,
      remainingDays: (json['remainingDays'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'id': instance.roomId,
      'opponent': instance.opponentName,
      'opponentProfile': instance.opponentProfileUrl,
      'title': instance.title,
      'lastMessage': instance.lastMessage,
      'type': instance.type,
      'updatedAt': instance.lastMessageTime.toIso8601String(),
      'unread': instance.hasUnreadMessages,
      'location': instance.location,
      'thumbnailUrl': instance.thumbnailUrl,
      'buildingType': instance.buildingType,
      'propertyType': instance.propertyType,
      'rentType': instance.rentType,
      'deposit': instance.deposit,
      'monthlyRent': instance.monthlyRent,
      'maintenance': instance.maintenance,
      'ticketType': instance.ticketType,
      'remainingDays': instance.remainingDays,
      'price': instance.price,
    };
