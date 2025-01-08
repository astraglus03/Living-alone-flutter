// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomDetailModel _$RoomDetailModelFromJson(Map<String, dynamic> json) =>
    RoomDetailModel(
      id: json['id'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      postType: json['postType'] as String,
      title: json['title'] as String,
      isTransferred: json['isTransferred'] as bool,
      location: json['location'] as String,
      buildingType: json['buildingType'] as String,
      propertyType: json['propertyType'] as String,
      rentType: json['rentType'] as String,
      deposit: (json['deposit'] as num).toInt(),
      maintenance: (json['maintenance'] as num).toInt(),
      monthlyRent: (json['monthlyRent'] as num?)?.toInt(),
      options:
          (json['options'] as List<dynamic>?)?.map((e) => e as String).toList(),
      facilities: (json['facilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      conditions: (json['conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      likes: (json['likes'] as num).toInt(),
      comments: (json['comments'] as num).toInt(),
      chatRooms: (json['chatRooms'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      room: (json['room'] as List<dynamic>)
          .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      additionalImages: (json['additionalImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      authorProfileUrl: json['authorProfileUrl'] as String,
      authorName: json['authorName'] as String,
      address: json['address'] as String,
      detailedAddress: json['detailedAddress'] as String,
      description: json['description'] as String,
      area: json['area'] as String,
      currentFloor: json['currentFloor'] as String,
      totalFloor: json['totalFloor'] as String,
      availableDate: json['availableDate'] as String,
      immediateEnter: json['immediateEnter'] as bool,
      commentList: (json['commentList'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoomDetailModelToJson(RoomDetailModel instance) =>
    <String, dynamic>{
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
      'room': instance.room,
      'additionalImages': instance.additionalImages,
      'authorProfileUrl': instance.authorProfileUrl,
      'authorName': instance.authorName,
      'address': instance.address,
      'detailedAddress': instance.detailedAddress,
      'description': instance.description,
      'area': instance.area,
      'currentFloor': instance.currentFloor,
      'totalFloor': instance.totalFloor,
      'availableDate': instance.availableDate,
      'immediateEnter': instance.immediateEnter,
      'commentList': instance.commentList,
    };
