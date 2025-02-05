// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inquiry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InquiryModel _$InquiryModelFromJson(Map<String, dynamic> json) => InquiryModel(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      answer: json['answer'] as String?,
      answeredAt: json['answeredAt'] == null
          ? null
          : DateTime.parse(json['answeredAt'] as String),
    );

Map<String, dynamic> _$InquiryModelToJson(InquiryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category': instance.category,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'answer': instance.answer,
      'answeredAt': instance.answeredAt?.toIso8601String(),
    };
