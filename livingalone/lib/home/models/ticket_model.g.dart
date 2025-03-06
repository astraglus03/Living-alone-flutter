// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel(
      id: json['id'] as String,
      postType: json['postType'] as String,
      title: json['title'] as String,
      location: json['location'] as String,
      ticketType: json['ticketType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isTransferred: json['isTransferred'] as bool,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'postType': instance.postType,
      'title': instance.title,
      'location': instance.location,
      'ticketType': instance.ticketType,
      'createdAt': instance.createdAt.toIso8601String(),
      'isTransferred': instance.isTransferred,
      'isFavorite': instance.isFavorite,
    };
