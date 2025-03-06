// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'handover_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandoverHistoryModel _$HandoverHistoryModelFromJson(
        Map<String, dynamic> json) =>
    HandoverHistoryModel(
      itemId: json['itemId'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      type: $enumDecode(_$PostTypeEnumMap, json['type'],
          unknownValue: PostType.room),
      createdAt: DateTime.parse(json['createdAt'] as String),
      viewCount: (json['viewCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      chatCount: (json['chatCount'] as num).toInt(),
      isTransferred: json['isTransferred'] as bool,
      isHidden: json['isHidden'] as bool? ?? false,
      buildingType: json['buildingType'] as String?,
      propertyType: json['propertyType'] as String?,
      rentType: json['rentType'] as String?,
      deposit: (json['deposit'] as num?)?.toInt(),
      monthlyRent: (json['monthlyRent'] as num?)?.toInt(),
      ticketType: json['ticketType'] as String?,
      remainingDays: (json['remainingDays'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$HandoverHistoryModelToJson(
        HandoverHistoryModel instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'title': instance.title,
      'location': instance.location,
      'thumbnailUrl': instance.thumbnailUrl,
      'type': _$PostTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'viewCount': instance.viewCount,
      'commentCount': instance.commentCount,
      'chatCount': instance.chatCount,
      'isTransferred': instance.isTransferred,
      'isHidden': instance.isHidden,
      'buildingType': instance.buildingType,
      'propertyType': instance.propertyType,
      'rentType': instance.rentType,
      'deposit': instance.deposit,
      'monthlyRent': instance.monthlyRent,
      'ticketType': instance.ticketType,
      'remainingDays': instance.remainingDays,
      'price': instance.price,
    };

const _$PostTypeEnumMap = {
  PostType.room: 'room',
  PostType.ticket: 'ticket',
};
