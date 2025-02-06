// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteModel _$FavoriteModelFromJson(Map<String, dynamic> json) =>
    FavoriteModel(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      type: $enumDecode(_$PostTypeEnumMap, json['type']),
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isTransferred: json['isTransferred'] as bool,
      location: json['location'] as String,
      buildingType: json['buildingType'] as String?,
      propertyType: json['propertyType'] as String?,
      rentType: json['rentType'] as String?,
      deposit: (json['deposit'] as num?)?.toInt(),
      monthlyRent: (json['monthlyRent'] as num?)?.toInt(),
      maintenance: (json['maintenance'] as num?)?.toInt(),
      ticketType: json['ticketType'] as String?,
      viewCount: (json['viewCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
      chatCount: (json['chatCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFavorite: json['isFavorite'] as bool,
    );

Map<String, dynamic> _$FavoriteModelToJson(FavoriteModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'type': _$PostTypeEnumMap[instance.type]!,
      'title': instance.title,
      'thumbnailUrl': instance.thumbnailUrl,
      'isTransferred': instance.isTransferred,
      'location': instance.location,
      'buildingType': instance.buildingType,
      'propertyType': instance.propertyType,
      'rentType': instance.rentType,
      'deposit': instance.deposit,
      'monthlyRent': instance.monthlyRent,
      'maintenance': instance.maintenance,
      'ticketType': instance.ticketType,
      'viewCount': instance.viewCount,
      'commentCount': instance.commentCount,
      'chatCount': instance.chatCount,
      'createdAt': instance.createdAt.toIso8601String(),
      'isFavorite': instance.isFavorite,
    };

const _$PostTypeEnumMap = {
  PostType.room: 'room',
  PostType.ticket: 'ticket',
};
