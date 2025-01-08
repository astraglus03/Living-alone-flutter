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
      additionalImages: (json['additionalImages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      authorProfileUrl: json['authorProfileUrl'] as String,
      authorProfileName: json['authorProfileName'] as String,
      address: json['address'] as String,
      remainingNum: json['remainingNum'] as String?,
      remainingTime: json['remainingTime'] as String?,
      maintenanceFee: json['maintenanceFee'] as String?,
      ticketIntroText: json['ticketIntroText'] as String,
      isPossibleUse: json['isPossibleUse'] as String,
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
      'additionalImages': instance.additionalImages,
      'authorProfileUrl': instance.authorProfileUrl,
      'authorProfileName': instance.authorProfileName,
      'address': instance.address,
      'remainingNum': instance.remainingNum,
      'remainingTime': instance.remainingTime,
      'maintenanceFee': instance.maintenanceFee,
      'ticketIntroText': instance.ticketIntroText,
      'isPossibleUse': instance.isPossibleUse,
    };
