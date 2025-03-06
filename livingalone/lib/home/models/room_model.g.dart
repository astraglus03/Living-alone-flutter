// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
      id: json['id'] as String,
      postType: json['postType'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      title: json['title'] as String,
      isTransferred: json['isTransferred'] as bool,
      location: json['location'] as String,
      buildingType: json['buildingType'] as String,
      propertyType: json['propertyType'] as String,
      rentType: json['rentType'] as String,
      deposit: (json['deposit'] as num).toInt(),
      monthlyRent: (json['monthlyRent'] as num?)?.toInt(),
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      conditions: (json['conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      maintenance: (json['maintenance'] as num).toInt(),
      likes: (json['likes'] as num).toInt(),
      comments: (json['comments'] as num).toInt(),
      chatRooms: (json['chatRooms'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
      'id': instance.id,
      'postType': instance.postType,
      'thumbnailUrl': instance.thumbnailUrl,
      'title': instance.title,
      'isTransferred': instance.isTransferred,
      'location': instance.location,
      'buildingType': instance.buildingType,
      'propertyType': instance.propertyType,
      'rentType': instance.rentType,
      'deposit': instance.deposit,
      'maintenance': instance.maintenance,
      'monthlyRent': instance.monthlyRent,
      'options': instance.options,
      'facilities': instance.facilities,
      'conditions': instance.conditions,
      'likes': instance.likes,
      'comments': instance.comments,
      'chatRooms': instance.chatRooms,
      'createdAt': instance.createdAt.toIso8601String(),
    };
