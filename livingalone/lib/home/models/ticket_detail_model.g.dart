// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketDetailModel _$TicketDetailModelFromJson(Map<String, dynamic> json) =>
    TicketDetailModel(
      id: json['id'] as String,
      postType: json['postType'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      ticketType: json['ticketType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isTransferred: json['isTransferred'] as bool,
      isFavorite: json['isFavorite'] as bool? ?? false,
      handoverPrice: (json['handoverPrice'] as num).toInt(),
      additionalImages: (json['additionalImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      authorProfileUrl: json['authorProfileUrl'] as String,
      authorName: json['authorName'] as String,
      address: json['address'] as String,
      detailedAddress: json['detailedAddress'] as String,
      remainingNum: (json['remainingNum'] as num?)?.toInt(),
      remainingTime: (json['remainingTime'] as num?)?.toInt(),
      maintenanceFee: (json['maintenanceFee'] as num?)?.toInt(),
      description: json['description'] as String,
      availableDate: json['availableDate'] as String,
      immediateEnter: json['immediateEnter'] as bool?,
    );

Map<String, dynamic> _$TicketDetailModelToJson(TicketDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postType': instance.postType,
      'title': instance.title,
      'location': instance.location,
      'ticketType': instance.ticketType,
      'createdAt': instance.createdAt.toIso8601String(),
      'isTransferred': instance.isTransferred,
      'isFavorite': instance.isFavorite,
      'handoverPrice': instance.handoverPrice,
      'additionalImages': instance.additionalImages,
      'authorProfileUrl': instance.authorProfileUrl,
      'authorName': instance.authorName,
      'address': instance.address,
      'detailedAddress': instance.detailedAddress,
      'remainingNum': instance.remainingNum,
      'remainingTime': instance.remainingTime,
      'maintenanceFee': instance.maintenanceFee,
      'description': instance.description,
      'availableDate': instance.availableDate,
      'immediateEnter': instance.immediateEnter,
    };
