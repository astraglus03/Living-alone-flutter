import 'package:json_annotation/json_annotation.dart';

part 'inquiry_model.g.dart';

abstract class InquiryModelBase{}

class InquiryModelError extends InquiryModelBase {
  final String message;

  InquiryModelError({
    required this.message,
  });
}

class InquiryModelLoading extends InquiryModelBase {}

@JsonSerializable()
class InquiryModel extends InquiryModelBase{
  final String id;
  final String category;
  final String title;
  final String content;
  final DateTime createdAt;
  // final String status;
  final String? answer;
  final DateTime? answeredAt;

  InquiryModel({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.createdAt,
    // required this.status,
    this.answer,
    this.answeredAt,
  });

  factory InquiryModel.fromJson(Map<String, dynamic> json) => _$InquiryModelFromJson(json);

  Map<String, dynamic> toJson() => _$InquiryModelToJson(this);
}