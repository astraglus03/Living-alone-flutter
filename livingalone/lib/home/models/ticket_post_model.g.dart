// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketPost _$TicketPostFromJson(Map<String, dynamic> json) => TicketPost(
      id: json['id'] as String,
      title: json['title'] as String,
      subTitle1: json['subTitle1'] as String,
      subTitle2: json['subTitle2'] as String,
      subTitle3: json['subTitle3'] as String,
      subTitle4: json['subTitle4'] as String,
      likes: (json['likes'] as num).toInt(),
      comments: (json['comments'] as num).toInt(),
      scraps: (json['scraps'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$TicketPostToJson(TicketPost instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subTitle1': instance.subTitle1,
      'subTitle2': instance.subTitle2,
      'subTitle3': instance.subTitle3,
      'subTitle4': instance.subTitle4,
      'likes': instance.likes,
      'comments': instance.comments,
      'scraps': instance.scraps,
      'createdAt': instance.createdAt.toIso8601String(),
    };
